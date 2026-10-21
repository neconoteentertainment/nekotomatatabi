package com.neconote.nekotomatatabi

import android.app.AlertDialog
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.ViewGroup
import android.widget.ArrayAdapter
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.Spinner
import android.widget.TextView
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import java.util.UUID

class MainActivity : FlutterActivity() {
    private var inboxChannel: MethodChannel? = null
    private val inbox by lazy { getSharedPreferences("favorite_share_inbox", MODE_PRIVATE) }
    private val pendingKey = "pending_favorite_sites_v1"
    private val destinations = arrayOf(
        "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
        "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
        "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県",
        "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県",
        "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県",
        "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県",
        "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県", "その他"
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        receiveSharedPage(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        receiveSharedPage(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        inboxChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
            "com.neconote.nekotomatatabi/share_inbox").apply {
            setMethodCallHandler { call, result ->
                when (call.method) {
                    // Read without deleting: Flutter acknowledges only after saving.
                    "takePendingFavoriteSites" -> {
                        val rows = readPending()
                        result.success((0 until rows.length()).mapNotNull { i ->
                            rows.optJSONObject(i)?.let { row ->
                                listOf("id", "prefecture", "title", "url", "createdAt")
                                    .associateWith { key -> row.optString(key) }
                            }
                        })
                    }
                    "acknowledgeFavoriteSites" -> {
                        val ids = (call.arguments as? List<*>)?.filterIsInstance<String>()?.toSet().orEmpty()
                        val remaining = JSONArray()
                        val rows = readPending()
                        for (i in 0 until rows.length()) {
                            val row = rows.optJSONObject(i) ?: continue
                            if (row.optString("id") !in ids) remaining.put(row)
                        }
                        if (inbox.edit().putString(pendingKey, remaining.toString()).commit()) {
                            result.success(null)
                        } else {
                            result.error("SAVE_FAILED", "共有データの更新に失敗しました。", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        inboxChannel?.setMethodCallHandler(null)
        inboxChannel = null
        super.cleanUpFlutterEngine(flutterEngine)
    }

    private fun readPending(): JSONArray = try {
        JSONArray(inbox.getString(pendingKey, "[]") ?: "[]")
    } catch (_: Exception) { JSONArray() }

    private fun receiveSharedPage(incoming: Intent?) {
        if (incoming?.action != Intent.ACTION_SEND) return
        // Consume the launch intent so Activity recreation does not register it twice.
        setIntent(Intent(this, MainActivity::class.java).setAction(Intent.ACTION_MAIN))
        val mime = incoming.type?.substringBefore(';')?.lowercase(Locale.ROOT)
        if (mime !in setOf("text/plain", "text/html", "text/uri-list")) return
        val text = incoming.getCharSequenceExtra(Intent.EXTRA_TEXT)?.toString().orEmpty()
        val candidates = mutableListOf(text)
        incoming.clipData?.let { clips ->
            for (i in 0 until clips.itemCount) {
                val item = clips.getItemAt(i)
                candidates.add(item.uri?.toString() ?: item.text?.toString().orEmpty())
            }
        }
        val url = candidates.asSequence().flatMap { value ->
            Regex("https?://[^\\s<>\\\"']+", RegexOption.IGNORE_CASE)
                .findAll(value).map { cleanSharedUrl(it.value) }
        }.firstOrNull { value ->
            val uri = Uri.parse(value)
            uri.scheme?.lowercase(Locale.ROOT) in setOf("http", "https") && !uri.host.isNullOrBlank()
        }
        if (url == null) {
            Toast.makeText(this, "共有データにWebページのURLが見つかりませんでした。", Toast.LENGTH_LONG).show()
            return
        }
        val title = incoming.getCharSequenceExtra(Intent.EXTRA_SUBJECT)?.toString()
            ?.takeIf { it.isNotBlank() }
            ?: incoming.getCharSequenceExtra(Intent.EXTRA_TITLE)?.toString()?.takeIf { it.isNotBlank() }
            ?: text.substringBefore(url).trim().takeIf { it.isNotBlank() }
            ?: Uri.parse(url).host.orEmpty()
        showRegistration(url, title)
    }

    private fun cleanSharedUrl(raw: String): String {
        var value = raw.trimEnd('。', '、')
        // Preserve balanced parentheses in URLs such as Wikipedia page names.
        for ((open, close) in listOf('(' to ')', '[' to ']', '（' to '）', '【' to '】')) {
            while (value.endsWith(close) && value.count { it == close } > value.count { it == open }) {
                value = value.dropLast(1)
            }
        }
        return value
    }

    private fun showRegistration(url: String, suggestedTitle: String) {
        val padding = (20 * resources.displayMetrics.density).toInt()
        val fields = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(padding, padding / 2, padding, padding / 2)
        }
        fun label(text: String) = TextView(this).apply {
            this.text = text
            setPadding(0, padding / 2, 0, padding / 4)
        }
        val title = EditText(this).apply {
            setText(suggestedTitle)
            hint = "サイト名"
            setSingleLine(true)
        }
        val destination = Spinner(this).apply {
            adapter = ArrayAdapter(this@MainActivity, android.R.layout.simple_spinner_dropdown_item, destinations)
            setSelection(destinations.lastIndex)
        }
        fields.addView(label("サイト名"))
        fields.addView(title)
        fields.addView(label(url))
        fields.addView(label("保存先"))
        fields.addView(destination, ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.WRAP_CONTENT))
        val dialog = AlertDialog.Builder(this)
            .setTitle("ねことまた旅に登録")
            .setView(ScrollView(this).apply { addView(fields) })
            .setNegativeButton("キャンセル", null)
            .setPositiveButton("お気に入りに登録", null)
            .create()
        dialog.setOnShowListener {
            dialog.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener {
                val formatter = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US).apply {
                    timeZone = TimeZone.getTimeZone("UTC")
                }
                val row = JSONObject().apply {
                    put("id", "android_share_${UUID.randomUUID()}")
                    put("prefecture", destinations[destination.selectedItemPosition])
                    put("title", title.text.toString().trim().ifEmpty { Uri.parse(url).host ?: url })
                    put("url", url)
                    put("createdAt", formatter.format(Date()))
                }
                val pending = readPending().put(row)
                if (!inbox.edit().putString(pendingKey, pending.toString()).commit()) {
                    Toast.makeText(this, "保存できませんでした。再度お試しください。", Toast.LENGTH_LONG).show()
                    return@setOnClickListener
                }
                inboxChannel?.invokeMethod("favoriteSitesAvailable", null)
                Toast.makeText(this, "お気に入りに登録しました。", Toast.LENGTH_SHORT).show()
                dialog.dismiss()
            }
        }
        dialog.show()
    }
}
