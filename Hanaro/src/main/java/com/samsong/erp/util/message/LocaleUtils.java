package com.samsong.erp.util.message;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.propertyeditors.LocaleEditor;
import org.springframework.util.StringUtils;


public class LocaleUtils {

    private LocaleUtils() {

    }


    public static Locale toLocale(String locale) {

        if (locale == null) {
            return null;
        }
        LocaleEditor led = new LocaleEditor();
        led.setAsText(locale);
        return (Locale) led.getValue();
    }


    public static String fromLocale(Locale locale) {

        if (locale == null) {
            return null;
        }
        LocaleEditor led = new LocaleEditor();
        led.setValue(locale);
        return led.getAsText();
    }


    public static Locale toLocale(String language, String country, String variant) {

        if (variant == null) {
            if (country == null) {
                if (language == null) {
                    return toLocale(null);
                }
                return toLocale(language);
            }
            return toLocale(String.format("%s_%s", language, country));
        }

        return toLocale(String.format("%s_%s_%s", language, country, variant));

    }


    public static String getLanguage(Locale locale) {

        if (locale != null && StringUtils.hasLength(locale.getLanguage())) {
            return locale.getLanguage();
        }
        return "";
    }


  
    public static String getCountry(Locale locale) {

        if (locale != null && StringUtils.hasLength(locale.getCountry())) {
            return locale.getCountry();
        }
        return "";
    }


    public static String getVariant(Locale locale) {

        if (locale != null && StringUtils.hasLength(locale.getVariant())) {
            return locale.getVariant();
        }
        return "";
    }


    public static Locale getParent(Locale locale) {

        if (locale == null) {
            return null;
        }
        if (StringUtils.hasLength(locale.getVariant())) {
            return new Locale(locale.getLanguage(), locale.getCountry());
        } else if (StringUtils.hasLength(locale.getCountry())) {
            return new Locale(locale.getLanguage());
        } else {
            return null;
        }
    }


    public static List<Locale> getPath(Locale locale, Locale defaultLocale) {

        List<Locale> path = new ArrayList<Locale>();

        boolean localeWasNull = locale == null;

        
        while (locale != null) {
            path.add(locale);
            locale = getParent(locale);
        }

        if (!localeWasNull && locale != defaultLocale) {
           
            while (defaultLocale != null) {
                path.add(defaultLocale);
                defaultLocale = getParent(defaultLocale);
            }

        }
      
        path.add(null);

        return path;
    }

}
