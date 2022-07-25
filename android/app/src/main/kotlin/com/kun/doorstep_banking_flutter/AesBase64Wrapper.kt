package com.kun.doorstep_banking_flutter

import android.util.Base64
import android.util.Log
import java.io.UnsupportedEncodingException
import java.security.Key
import java.security.spec.KeySpec
import javax.crypto.Cipher
import javax.crypto.SecretKey
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec

class AesBase64Wrapper {
//    private val IV = "T3CH10G!C@MNYTRF"
//
//    //    private static String PASSWORD = "V222201B01844CUS001";
//    private  val SALT = "InOknmq1C+NCZSi0a9NjIQ=="
//
//    fun encryptAndEncode(raw: String, pwd: String): String {
//        try {
//            val c = getCipher(Cipher.ENCRYPT_MODE, pwd)
//            val encryptedVal = c.doFinal(getBytes(raw))
//            val s = Base64.encodeToString(encryptedVal, Base64.NO_WRAP)
//            return s;
//            Log.d(":::","s")
//        } catch (t: Throwable) {
//            throw RuntimeException(t)
//        }
//
//    }
//
//    @Throws(Exception::class)
//    fun decodeAndDecrypt(encrypted: String, pwd: String): String {
//        val decodedValue = Base64.decode(encrypted.toByteArray(), Base64.NO_WRAP)
//        val c = getCipher(Cipher.DECRYPT_MODE, pwd)
//        val decValue = c.doFinal(decodedValue)
//        return String(decValue)
//        Log.d(":::","decValue.toString()")
//    }
//
////    private static String getString(byte[] bytes) throws UnsupportedEncodingException {
////        return new String(bytes, "UTF-8");
////    }
//
//    @Throws(UnsupportedEncodingException::class)
//    private fun getBytes(str: String): ByteArray {
//        return str.toByteArray(charset("UTF-8"))
//    }
//
//    @Throws(Exception::class)
//    private fun getCipher(mode: Int, pwd: String): Cipher {
//        val c = Cipher.getInstance("AES/CBC/PKCS5Padding")
//        val iv = getBytes(MainActivity.IV)
//        c.init(mode, generateKey(pwd), IvParameterSpec(iv))
//        return c
//    }
//
//    @Throws(Exception::class)
//    private fun generateKey(pwd: String): Key {
//        val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1")
//        val password = pwd.toCharArray()
//        Log.e("pwd", "-----$pwd")
//        val salt = getBytes(MainActivity.SALT)
//        val spec: KeySpec = PBEKeySpec(password, salt, 65536, 128)
//        val tmp = factory.generateSecret(spec)
//        val encoded = tmp.encoded
//        return SecretKeySpec(encoded, "AES")
//    }

}