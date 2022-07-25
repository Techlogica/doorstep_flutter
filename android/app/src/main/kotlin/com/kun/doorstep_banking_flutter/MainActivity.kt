package com.kun.doorstep_banking_flutter

import android.annotation.TargetApi
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Base64
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.UnsupportedEncodingException
import java.security.Key
import java.security.spec.KeySpec
import javax.crypto.Cipher
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec

class MainActivity: io.flutter.embedding.android.FlutterActivity(){
    var responseBody: String = ""
    var requestBody: String = ""
    var deviceId: String = ""
    val  IV = "T3CH10G!C@MNYTRF"

    //    private static String PASSWORD = "V222201B01844CUS001";
    val SALT = "InOknmq1C+NCZSi0a9NjIQ=="

    private val CHANNEL = "flutter.native/Encryptionhelper"//Name as per your convenience…!!!
    
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            deviceId = call.argument<String>("DeviceId").toString()
            if (call.hasArgument("response")){
                responseBody = call.argument<String>("response").toString()
                if (call.method == "ResponseDecrypt") {
                    val response = decodeAndDecrypt(responseBody, deviceId)
                    result.success(response)
                }
            }
            if (call.hasArgument("request")){
                requestBody = call.argument<String>("request").toString()
                if (call.method == "RequestEncrypt") {
                    val request = encryptAndEncode(requestBody,deviceId)
                    result.success(request)
                }
            }
// Note: this method is invoked on the main thread.
// TODO

        }
    }

    @TargetApi(Build.VERSION_CODES.FROYO)
    fun encryptAndEncode(raw: String, pwd: String): String {
        try {
            val c = getCipher(Cipher.ENCRYPT_MODE, pwd)
            val encryptedVal = c.doFinal(getBytes(raw))
            val s = Base64.encodeToString(encryptedVal, Base64.NO_WRAP)
            return s;
            Log.d(":::","s")
        } catch (t: Throwable) {
            throw RuntimeException(t)
        }

    }

    @TargetApi(Build.VERSION_CODES.FROYO)
    @Throws(Exception::class)
    fun decodeAndDecrypt(encrypted: String, pwd: String): String {
        try {
            val decodedValue = Base64.decode(encrypted.toByteArray(), Base64.NO_WRAP)
            val c = getCipher(Cipher.DECRYPT_MODE, pwd)
            val decValue = c.doFinal(decodedValue)
            return String(decValue)
            Log.d(":::", "decValue.toString()")
        }catch (t: Throwable) {
            throw RuntimeException(t)
        }
    }

//    @Throws(UnsupportedEncodingException::class)
//    private fun getString(bytes: ByteArray): String {
//        return String(bytes, "UTF-8")
//    }

    @Throws(UnsupportedEncodingException::class)
    private fun getBytes(str: String): ByteArray {
        return str.toByteArray(charset("UTF-8"))
    }

    @Throws(Exception::class)
    private fun getCipher(mode: Int, pwd: String): Cipher {
        val c = Cipher.getInstance("AES/CBC/PKCS5Padding")
        val iv = getBytes(IV)
        c.init(mode, generateKey(pwd), IvParameterSpec(iv))
        return c
    }

    @Throws(Exception::class)
    private fun generateKey(pwd: String): Key {
        val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1")
        val password = pwd.toCharArray()
        Log.e("pwd", "-----$pwd")
        val salt = getBytes(SALT)
        val spec: KeySpec = PBEKeySpec(password, salt, 65536, 128)
        val tmp = factory.generateSecret(spec)
        val encoded = tmp.encoded
        return SecretKeySpec(encoded, "AES")
    }

    companion object {

    }
}

