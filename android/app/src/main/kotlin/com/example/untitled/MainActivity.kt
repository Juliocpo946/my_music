package com.example.untitled

import android.app.Activity
import android.app.RecoverableSecurityException
import android.content.ContentUris
import android.content.IntentSender
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.juliocpo946.mymusic/metadata"
    private val DELETE_REQUEST_CODE = 1001
    private var pendingDeleteResult: MethodChannel.Result? = null
    private var pendingDeleteUri: Uri? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "scanLocalSongs") {
                Thread {
                    val songs = scanLocalSongs()
                    runOnUiThread {
                        result.success(songs)
                    }
                }.start()
            }
            else if (call.method == "deleteLocalFile") {
                val filePath = call.argument<String>("filePath")
                if (filePath == null) {
                    result.success(false)
                } else {
                    Thread {
                        val deleted = deleteLocalFile(filePath, result)
                        if (deleted != null) {
                            runOnUiThread {
                                result.success(deleted)
                            }
                        }
                    }.start()
                }
            }
            else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: android.content.Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == DELETE_REQUEST_CODE) {
            val success = if (resultCode == Activity.RESULT_OK) {
                pendingDeleteUri?.let {
                    try {
                        contentResolver.delete(it, null, null) > 0
                    } catch (e: Exception) {
                        false
                    }
                } ?: false
            } else {
                false
            }
            pendingDeleteResult?.success(success)
            pendingDeleteResult = null
            pendingDeleteUri = null
        }
    }

    private fun deleteLocalFile(filePath: String, result: MethodChannel.Result): Boolean? {
        val contentResolver = applicationContext.contentResolver
        val collection = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL)
        } else {
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
        }

        val selection = "${MediaStore.Audio.Media.DATA} = ?"
        val selectionArgs = arrayOf(filePath)

        try {
            val cursor = contentResolver.query(collection, arrayOf(MediaStore.Audio.Media._ID), selection, selectionArgs, null)
            cursor?.use {
                if (it.moveToFirst()) {
                    val id = it.getLong(it.getColumnIndexOrThrow(MediaStore.Audio.Media._ID))
                    val uri = ContentUris.withAppendedId(collection, id)

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        try {
                            val rowsDeleted = contentResolver.delete(uri, null, null)
                            return rowsDeleted > 0
                        } catch (securityException: SecurityException) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                val recoverableSecurityException = securityException as? RecoverableSecurityException
                                    ?: throw securityException

                                pendingDeleteResult = result
                                pendingDeleteUri = uri
                                val intentSender = recoverableSecurityException.userAction.actionIntent.intentSender
                                runOnUiThread {
                                    startIntentSenderForResult(intentSender, DELETE_REQUEST_CODE, null, 0, 0, 0, null)
                                }
                                return null
                            } else {
                                throw securityException
                            }
                        }
                    } else {
                        val rowsDeleted = contentResolver.delete(uri, null, null)
                        return rowsDeleted > 0
                    }
                }
            }
            return false
        } catch (e: Exception) {
            return false
        }
    }

    private fun scanLocalSongs(): List<Map<String, Any?>> {
        val songList = mutableListOf<Map<String, Any?>>()
        val collection =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL)
            } else {
                MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
            }

        val projection = arrayOf(
            MediaStore.Audio.Media._ID,
            MediaStore.Audio.Media.TITLE,
            MediaStore.Audio.Media.ARTIST,
            MediaStore.Audio.Media.ALBUM,
            MediaStore.Audio.Media.DURATION,
            MediaStore.Audio.Media.DATA
        )

        val selection = MediaStore.Audio.Media.IS_MUSIC + " != 0"

        val query = contentResolver.query(
            collection,
            projection,
            selection,
            null,
            null
        )

        query?.use { cursor ->
            val idColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media._ID)
            val titleColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.TITLE)
            val artistColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ARTIST)
            val albumColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.ALBUM)
            val durationColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DURATION)
            val pathColumn = cursor.getColumnIndexOrThrow(MediaStore.Audio.Media.DATA)

            while (cursor.moveToNext()) {
                val id = cursor.getLong(idColumn)
                val title = cursor.getString(titleColumn)
                val artist = cursor.getString(artistColumn)
                val album = cursor.getString(albumColumn)
                val duration = cursor.getLong(durationColumn)
                val path = cursor.getString(pathColumn)

                val contentUri: Uri = ContentUris.withAppendedId(
                    MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
                    id
                )

                val songMap = mapOf(
                    "id" to id,
                    "title" to title,
                    "artist" to artist,
                    "album" to album,
                    "duration" to duration,
                    "filePath" to path,
                    "albumArtUri" to contentUri.toString()
                )
                songList.add(songMap)
            }
        }
        return songList
    }
}