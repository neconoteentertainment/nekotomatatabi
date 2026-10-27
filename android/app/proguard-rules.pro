# WorkManager uses Room to instantiate its generated database implementation.
# Preserve the database names and constructors used by reflection in release builds.
-keep class androidx.work.impl.WorkDatabase { *; }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
