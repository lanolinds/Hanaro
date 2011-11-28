package com.samsong.erp.util.message;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.MessageSource;
import org.springframework.context.support.AbstractMessageSource;
import org.springframework.util.Assert;

public class JdbcMessageSource extends AbstractMessageSource implements InitializingBean {

    protected Map<Locale, List<String>> resolvingPath = new HashMap<Locale, List<String>>();
    protected Map<String, Map<String, MessageFormat>> messages;
    protected Locale defaultLocale;

    protected MessageProvider messageProvider;
    protected List<String> basenames = new ArrayList<String>();

    
    protected boolean autoInitialize = true;

   
    protected boolean basenameRestriction = false;


  
    public void initialize() {

        
        resolvingPath = new HashMap<Locale, List<String>>();

        if (!basenameRestriction) {
            basenames = new ArrayList<String>();
            basenames.addAll(messageProvider.getAvailableBaseNames());

        }

        messages = new HashMap<String, Map<String, MessageFormat>>();
        for (String basename : basenames) {
            initialize(basename);
        }
    }


    protected void initialize(String basename) {

        Messages messagesForBasename = messageProvider.getMessages(basename);
        for (Locale locale : messagesForBasename.getLocales()) {
            Map<String, String> codeToMessage = messagesForBasename.getMessages(locale);
            for (String code : codeToMessage.keySet()) {
                addMessage(basename, locale, code, createMessageFormat(codeToMessage.get(code), locale));
            }
        }
    }


    private void addMessage(String basename, Locale locale, String code, MessageFormat messageFormat) {

        String localeString = basename + "_" + (locale != null ? locale.toString() : "");
        Map<String, MessageFormat> codeMap = messages.get(localeString);
        if (codeMap == null) {
            codeMap = new HashMap<String, MessageFormat>();
            messages.put(localeString, codeMap);
        }

        codeMap.put(code, messageFormat);
    }


   
    @Override
    protected MessageFormat resolveCode(String code, Locale locale) {

        for (String basename : basenames) {
            List<String> paths = getPath(locale);
            for (String loc : paths) {
                Map<String, MessageFormat> formatMap = messages.get(basename + loc);
                if (formatMap != null) {
                    MessageFormat format = formatMap.get(code);
                    if (format != null) {
                        return format;
                    }
                }
            }
        }

        return null;
    }


    private List<String> getPath(Locale locale) {

        List<String> path = resolvingPath.get(locale);
        if (path == null) {
            path = new ArrayList<String>();

            List<Locale> localePath = LocaleUtils.getPath(locale, getDefaultLocale());
            for (Locale loc : localePath) {
                if (loc == null) {
                    path.add("_");
                } else {

                    String language = LocaleUtils.getLanguage(loc);
                    String country = LocaleUtils.getCountry(loc);
                    String variant = LocaleUtils.getVariant(loc);
                    if (!variant.isEmpty()) {
                        path.add(String.format("_%s_%s_%s", language, country, variant));
                    } else if (!country.isEmpty()) {
                        path.add(String.format("_%s_%s", language, country));
                    } else if (!language.isEmpty()) {
                        path.add(String.format("_%s", language));
                    }
                }

            }

            resolvingPath.put(locale, path);
        }
        return path;
    }


    public Locale getDefaultLocale() {

        return defaultLocale;
    }


   
    public void setDefaultLocale(Locale defaultLocale) {

        this.defaultLocale = defaultLocale;
    }


  
    public void setMessageProvider(MessageProvider messageProvider) {

        Assert.notNull(messageProvider);

        this.messageProvider = messageProvider;
    }


  
    public void setBasename(String basename) {

        basenameRestriction = true;
        this.basenames = new ArrayList<String>();
        basenames.add(basename);
    }


   
    public void setBasenames(List<String> basenames) {

        Assert.notNull(basenames);

        if (!basenames.isEmpty()) {
            basenameRestriction = true;
            this.basenames = basenames;
        }
    }


    
    public void afterPropertiesSet() throws Exception {

        if (autoInitialize) {
            initialize();
        }

    }


    
    public void setAutoInitialize(boolean autoInitialize) {

        this.autoInitialize = autoInitialize;
    }
    
    public Messages getMessages(String basename){
    	return this.messageProvider.getMessages(basename);
    }
    
    public void persistMessage(String basename,Locale locale,String key,String value){
    	if(this.messageProvider instanceof JdbcMessageProvider){
    		((JdbcMessageProvider) messageProvider).persistMessage(basename, locale, key, value);
    	}
    	this.initialize(basename);
    }
    

}
