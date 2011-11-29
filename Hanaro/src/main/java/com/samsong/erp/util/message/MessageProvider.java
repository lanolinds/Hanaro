package com.samsong.erp.util.message;

import java.util.Collection;


public interface MessageProvider {


    Messages getMessages(String basename);


    Collection<String> getAvailableBaseNames();
}
