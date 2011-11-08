package com.samsong.erp.util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import org.springframework.security.core.codec.Base64;


public class ClientFileNameEncoder {
	
	public static String encodeFileName(String fileName, String userAgent) throws UnsupportedEncodingException{
		if (null != userAgent && -1 != userAgent.indexOf("MSIE")) {
            fileName = fileName.replace(" ", "_");
                    //IE는 UTF-8 인코딩을 이해한다.
                    return URLEncoder.encode(fileName, "UTF-8");
            } else if (null != userAgent && -1 != userAgent.indexOf("Mozilla")) {
                    // Mozilla 계열은 Base 64 인코딩을 이해한다.
            		return "=?UTF-8?B?" + (new String(Base64.encode(fileName.getBytes("UTF-8")))) + "?=";
            } else {
                    return fileName;
            }
    }

}
