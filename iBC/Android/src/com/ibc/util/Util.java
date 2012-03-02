package com.ibc.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import java.security.SignatureException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import vn.lmchanh.lib.time.MCDate;

import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.Canvas;
import android.graphics.LinearGradient;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Paint.Align;
import android.graphics.Shader.TileMode;
import android.util.Base64;

public class Util {
	public static Bitmap resizeBimap(Bitmap bitmap, int newWidth, int newHeight) {
		int width = bitmap.getWidth();
		int height = bitmap.getHeight();
		float scaleWidth = ((float) newWidth) / width;
		float scaleHeight = ((float) newHeight) / height;
		Matrix matrix = new Matrix();
		matrix.postScale(scaleWidth, scaleHeight);
		Bitmap resizeBitmap = Bitmap.createBitmap(bitmap, 0, 0, width, height,
				matrix, true);
		return resizeBitmap;
	}
	
	public static String getCurrentTimeString() {
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmm");
		Date date = new Date();
		return dateFormat.format(date);
	}
	
	public static String getConcatenatedString() {
		String string = com.ibc.util.Config.KinectiaAppId + getCurrentTimeString();
		return string;
	}
	
	public static String hashStringParameter() {
		String rs = getConcatenatedString();
		rs = hashMac(rs);
		return rs;
	}
	
	public static MCDate mcDateFromDateString(String strDate) {
		MCDate mcDate = null;
		try {
			DateFormat formatter;
			Date date;
			formatter = new SimpleDateFormat("yyyyMMdd");

			date = (Date) formatter.parse(strDate);
			mcDate = new MCDate(date);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return mcDate;
	}
	
	/**
	 * Encryption of a given text using the provided secretKey
	 * 
	 * @param text
	 * @param secretKey
	 * @return the encoded string
	 * @throws SignatureException
	 */
	public static String hashMac(String text) {

		try {
			String secretKey = com.ibc.util.Config.SECRET_KEY;
			
			Key sk = new SecretKeySpec(secretKey.getBytes("UTF-8"), com.ibc.util.Config.HASH_ALGORITHM);
			
			Mac mac = Mac.getInstance(sk.getAlgorithm());
			mac.init(sk);
			final byte[] hmac = mac.doFinal(text.getBytes("UTF-8"));
			
			String hashString = android.util.Base64.encodeToString(hmac, Base64.NO_WRAP);//Base64Coder.encodeLines(hmac);//new String(StringUtil.encodeHex(hmac, false));
			return hashString;//StringUtil.getHexString(hmac);
		} catch (NoSuchAlgorithmException e1) {
			// throw an exception or pick a different encryption method
			System.out.println(
					"error building signature, no such algorithm in device "
							+ com.ibc.util.Config.HASH_ALGORITHM);
		} catch (InvalidKeyException e) {
			System.out.println(
					"error building signature, invalid key "
							+ com.ibc.util.Config.HASH_ALGORITHM);
		} catch (NoSuchMethodError e) {
			System.out.println(e.getMessage());
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
     *  Convenience method to convert a byte array to a hex string.
     *
     * @param  data  the byte[] to convert
     * @return String the converted byte[]
     */
    public static String bytesToHex(byte[] data) {
        StringBuffer buf = new StringBuffer();
        for (int i = 0; i < data.length; i++) {
            buf.append(byteToHex(data[i]).toUpperCase());
        }
        return (buf.toString());
    }
 
 
    /**
     *  method to convert a byte to a hex string.
     *
     * @param  data  the byte to convert
     * @return String the converted byte
     */
    public static String byteToHex(byte data) {
        StringBuffer buf = new StringBuffer();
        buf.append(toHexChar((data >>> 4) & 0x0F));
        buf.append(toHexChar(data & 0x0F));
        return buf.toString();
    }
 
 
    /**
     *  Convenience method to convert an int to a hex char.
     *
     * @param  i  the int to convert
     * @return char the converted char
     */
    public static char toHexChar(int i) {
        if ((0 <= i) && (i <= 9)) {
            return (char) ('0' + i);
        } else {
            return (char) ('a' + (i - 10));
        }
    }
	
	public static Bitmap cropBitmap(Bitmap bitmap, int newWidth, int newHeight) {
		Bitmap resizeBitmap = Bitmap.createScaledBitmap(bitmap, newWidth,
				bitmap.getHeight() * newWidth / bitmap.getWidth(), true);
		resizeBitmap = Bitmap.createBitmap(resizeBitmap, 0, 0, newWidth,
				newHeight);
		return resizeBitmap;
	}

	public static String convertStreamToString(InputStream is) {

		if (is != null) {
			Writer writer = new StringWriter();

			char[] buffer = new char[1024];
			try {
				Reader reader = new BufferedReader(new InputStreamReader(is,
						"UTF-8"));
				int n;
				while ((n = reader.read(buffer)) != -1) {
					writer.write(buffer, 0, n);
				}
			} catch (IOException e) {
				return "";
			} finally {
				try {
					is.close();
				} catch (IOException e) {

				}
			}
			return writer.toString();
		} else {
			return "";
		}
	}

	public static Bitmap createReflectedImages(Bitmap originalImage) {
		// The gap we want between the reflection and the original image
		final int reflectionGap = 2;
		int width = originalImage.getWidth();
		int height = originalImage.getHeight();
		// This will not scale but will flip on the Y axis
		Matrix matrix = new Matrix();
		matrix.preScale(1, -1);
		// matrix.preRotate(180);

		// Create a Bitmap with the flip matrix applied to it.
		// We only want the bottom half of the image
		Bitmap mirrowbitmap = Bitmap.createBitmap(originalImage, 0, 0,
				width, height, matrix, false);
		Bitmap reflectionImage = Bitmap.createBitmap(mirrowbitmap, 0, 0,
				width, height / 3);
		// Create a new bitmap with same width but taller to fit
		// reflection
		Bitmap bitmapWithReflection = Bitmap.createBitmap(width,
				(height * 4 / 3), Config.ARGB_8888);
		// Create a new Canvas with the bitmap that's big enough for
		// the image plus gap plus reflection
		Canvas canvas = new Canvas(bitmapWithReflection);
		// Draw in the original image
		canvas.drawBitmap(originalImage, 0, 0, null);
		// Draw in the gap
		Paint deafaultPaint = new Paint();
		canvas.drawRect(0, height + reflectionGap, width, height
				+ reflectionGap, deafaultPaint);
		// Draw in the reflection
		canvas.drawBitmap(reflectionImage, 0, height + reflectionGap , null);

		// Create a shader that is a linear gradient that covers the
		// reflection
		Paint paint = new Paint();
		LinearGradient shader = new LinearGradient(0,
				originalImage.getHeight(), 0, bitmapWithReflection.getHeight()
						+ reflectionGap, 0x55ffffff, 0x00ffffff, TileMode.CLAMP);
		// Set the paint to use this shader (linear gradient)
		paint.setShader(shader);
		// Set the Transfer mode to be porter duff and destination in
		// paint.setXfermode(new PorterDuffXfermode(Mode.DST_IN));
		// Draw a rectangle using the paint with our linear gradient
		canvas.drawRect(0, height, width, bitmapWithReflection.getHeight()
				+ reflectionGap, paint);
		// mImages[index++]._imageView = imageView;
		return bitmapWithReflection;
	}

	public static String removeHTML(String htmlString) {
		// Remove HTML tag from java String
		String noHTMLString = htmlString.replaceAll("\\<.*?\\>", "");

		// Remove Carriage return from java String
		noHTMLString = noHTMLString.replaceAll("\r", "<br/>");

		// Remove New line from java string and replace html break
		noHTMLString = noHTMLString.replaceAll("\'", "&#39;");
		noHTMLString = noHTMLString.replaceAll("\"", "&quot;");
		return noHTMLString;
	}
	
	public static String formatDurationFromMs(long duration, boolean padding) {
		duration = duration / 1000;
		long hh = duration / 3600;
		long mm = (duration % 3600) / 60;
		long ss = duration % 60;
		String text = "";
		if (padding) {
			if (hh > 0) {
				text = String.format("%02d:%02d:%02d", hh, mm, ss);
			} else {
				text = String.format("%02d:%02d", mm, ss);
			}
		} else {
			if (hh > 0) {
				text = String.format("%d:%d:%02d", hh, mm, ss);
			} else {
				text = String.format("%d:%02d", mm, ss);
			}
		}
		return text;
	}
	
	public static Bitmap createReflectedImages(Bitmap originalImage, String song, String artist) {
		// The gap we want between the reflection and the original image
		final int reflectionGap = 2;
		int width = originalImage.getWidth();
		int height = originalImage.getHeight();
		// This will not scale but will flip on the Y axis
		Matrix matrix = new Matrix();
		matrix.preScale(1, -1);
		// matrix.preRotate(180);

		// Create a Bitmap with the flip matrix applied to it.
		// We only want the bottom half of the image
		Bitmap mirrowbitmap = Bitmap.createBitmap(originalImage, 0, 0,
				width, height, matrix, false);
		Bitmap reflectionImage = Bitmap.createBitmap(mirrowbitmap, 0, 0,
				width, height / 3);
		// Create a new bitmap with same width but taller to fit
		// reflection
		Bitmap bitmapWithReflection = Bitmap.createBitmap(width,
				(height * 4 / 3), Config.ARGB_8888);
		// Create a new Canvas with the bitmap that's big enough for
		// the image plus gap plus reflection
		Canvas canvas = new Canvas(bitmapWithReflection);
		// Draw in the original image
		canvas.drawBitmap(originalImage, 0, 0, null);
		// Draw in the gap
		Paint deafaultPaint = new Paint();
		canvas.drawRect(0, height + reflectionGap, width, height
				+ reflectionGap, deafaultPaint);
		// Draw in the reflection
		//deafaultPaint.setColor(R.color.black);
		
		canvas.drawBitmap(reflectionImage, 0, height + reflectionGap , null);
		// Create a shader that is a linear gradient that covers the
		// reflection
		Paint paint = new Paint();
		LinearGradient shader = new LinearGradient(0,
				originalImage.getHeight(), 0, bitmapWithReflection.getHeight()
						+ reflectionGap, 0x55ffffff, 0x00ffffff, TileMode.CLAMP);
		// Set the paint to use this shader (linear gradient)
		paint.setShader(shader);
		// Set the Transfer mode to be porter duff and destination in
		// paint.setXfermode(new PorterDuffXfermode(Mode.DST_IN));
		// Draw a rectangle using the paint with our linear gradient
		canvas.drawRect(0, height, width, bitmapWithReflection.getHeight()
				+ reflectionGap, paint);
		deafaultPaint.setTextSize(18);
		deafaultPaint.setTextAlign(Align.CENTER);
		canvas.drawText((song != null) ? song : "unknown song", width/2 ,height + reflectionGap + 20, deafaultPaint);
		canvas.drawText((artist != null) ? artist : "unknown artist", width/2 ,height + reflectionGap + 40, deafaultPaint);
		// mImages[index++]._imageView = imageView;
		return bitmapWithReflection;
	}

}
