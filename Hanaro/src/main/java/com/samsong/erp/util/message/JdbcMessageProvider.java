package com.samsong.erp.util.message;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.util.Assert;


public class JdbcMessageProvider implements MessageProvider, MessageAcceptor {

    private static final String QUERY_INSERT = "INSERT INTO %s (%s, %s, %s, %s, %s, %s) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String QUERY_DELETE = "DELETE FROM %s WHERE %s = ?";
    private static final String QUERY_SELECT_BASENAMES = "SELECT DISTINCT %s from %s";
    private static final String QUERY_SELECT_MESSAGES = "SELECT %s,%s,%s,%s,%s FROM %s WHERE %s = ?";

    private JdbcTemplate template;

    private String languageColumn = "language";
    private String countryColumn = "country";
    private String variantColumn = "variant";
    private String basenameColumn = "basename";
    private String keyColumn = "key";
    private String messageColumn = "message";
    private String tableName = "Message";

    private String delimiter = "\"";

    private final MessageExtractor extractor = new MessageExtractor();


    public Messages getMessages(String basename) {

        String query =
                String.format(QUERY_SELECT_MESSAGES, addDelimiter(languageColumn), addDelimiter(countryColumn),
                        addDelimiter(variantColumn), addDelimiter(keyColumn), addDelimiter(messageColumn),
                        addDelimiter(tableName), addDelimiter(basenameColumn));

        return template.query(query, new Object[] { basename }, extractor);
    }


    public void setMessages(String basename, Messages messages) {

        deleteMessages(basename);

        String query =
                String.format(QUERY_INSERT, addDelimiter(tableName), addDelimiter(basenameColumn),
                        addDelimiter(languageColumn), addDelimiter(countryColumn), addDelimiter(variantColumn),
                        addDelimiter(keyColumn), addDelimiter(messageColumn));

        for (Locale locale : messages.getLocales()) {

            insert(query, basename, LocaleUtils.getLanguage(locale), LocaleUtils.getCountry(locale),
                    LocaleUtils.getVariant(locale), messages.getMessages(locale));

        }

    }


    private void insert(String query, final String basename, final String language, final String country,
            final String variant, final Map<String, String> messages) {

        final Iterator<Map.Entry<String, String>> messagesIterator = messages.entrySet().iterator();

        template.batchUpdate(query, new BatchPreparedStatementSetter() {

            public void setValues(PreparedStatement ps, int i) throws SQLException {

                Map.Entry<String, String> entry = messagesIterator.next();
                ps.setString(1, basename);
                ps.setString(2, language);
                ps.setString(3, country);
                ps.setString(4, variant);
                ps.setString(5, entry.getKey());
                ps.setString(6, entry.getValue());

            }


            public int getBatchSize() {

                return messages.size();
            }
        });

    }


    private void deleteMessages(final String basename) {

        String query = String.format(QUERY_DELETE, addDelimiter(tableName), addDelimiter(basenameColumn));

        template.update(query, basename);

    }


    public String getLanguageColumn() {

        return languageColumn;
    }



    public void setLanguageColumn(String languageColumn) {

        Assert.notNull(languageColumn);

        this.languageColumn = languageColumn;
    }


    public String getCountryColumn() {

        return countryColumn;
    }


    public void setCountryColumn(String countryColumn) {

        Assert.notNull(countryColumn);

        this.countryColumn = countryColumn;
    }


    public String getVariantColumn() {

        return variantColumn;
    }


  
    public void setVariantColumn(String variantColumn) {

        Assert.notNull(variantColumn);
        this.variantColumn = variantColumn;
    }


    
    public String getKeyColumn() {

        return keyColumn;
    }


   
    public void setKeyColumn(String keyColumn) {

        Assert.notNull(keyColumn);

        this.keyColumn = keyColumn;
    }


    public String getMessageColumn() {

        return messageColumn;
    }


  
    public void setMessageColumn(String messageColumn) {

        Assert.notNull(messageColumn);
        this.messageColumn = messageColumn;
    }


  
    public String getTableName() {

        return tableName;
    }


    
    public String getBasenameColumn() {

        return basenameColumn;
    }


   
    public void setBasenameColumn(String basenameColumn) {

        this.basenameColumn = basenameColumn;
    }


    
    public void setTableName(String tableName) {

        Assert.notNull(tableName);
        this.tableName = tableName;
    }


    public void setDataSource(DataSource dataSource) {

        Assert.notNull(dataSource);
        this.template = new JdbcTemplate(dataSource);
    }

    
    class MessageExtractor implements ResultSetExtractor<Messages> {

        public Messages extractData(ResultSet rs) throws SQLException, DataAccessException {

            Messages messages = new Messages();

            while (rs.next()) {
                String language = rs.getString(languageColumn);
                String country = rs.getString(countryColumn);
                String variant = rs.getString(variantColumn);
                String key = rs.getString(keyColumn);
                String message = rs.getString(messageColumn);

                Locale locale = LocaleUtils.toLocale(language, country, variant);
                messages.addMessage(locale, key, message);
            }

            return messages;
        }

    }


    
    public String getDelimiter() {

        return delimiter;
    }


    
    public void setDelimiter(String delimiter) {

        Assert.notNull(delimiter);
        this.delimiter = delimiter;
    }


    
    public List<String> getAvailableBaseNames() {

        List<String> basenames =
                template.queryForList(
                        String.format(QUERY_SELECT_BASENAMES, addDelimiter(basenameColumn), addDelimiter(tableName)),
                        String.class);
        return basenames;
    }


    protected String addDelimiter(String name) {

        return String.format("%s%s%s", delimiter, name, delimiter);
    }
    
    public void persistMessage(String basename,Locale locale, String key, String value){
    	String sql = "exec JdbcMessageProvider_persistMessage ?,?,?,?,?;";
    	template.update(sql, basename,locale.getLanguage(),locale.getCountry(),key,value);
    }

}
