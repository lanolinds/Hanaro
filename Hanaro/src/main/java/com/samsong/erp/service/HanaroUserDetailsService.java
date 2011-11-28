package com.samsong.erp.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Locale;

import javax.sql.DataSource;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.GrantedAuthorityImpl;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.samsong.erp.model.HanaroUser;

public class HanaroUserDetailsService implements UserDetailsService {

	private JdbcTemplate jdbc;
	
	public HanaroUserDetailsService(DataSource ds){
		this.jdbc = new JdbcTemplate(ds);
	}
	
	@Override
	public UserDetails loadUserByUsername(final String username)
			throws UsernameNotFoundException, DataAccessException {
		
		String sql = "exec HanaroUserDetailsService_loadUserByUsername ?;";
		return jdbc.queryForObject(sql, new Object[]{username},new RowMapper<User>() {

			@Override
			public User mapRow(ResultSet rs, int i) throws SQLException {
				return new HanaroUser(rs.getString("username"),rs.getString("password"),
						rs.getBoolean("enabled"),true,true, true,new Locale(rs.getString("lang"),rs.getString("country")), getAuthorities(username));
			}
		});
	}
	
	private List<GrantedAuthority> getAuthorities(String username){
		String sql = "select authority from authorities where username=?;";
		List<GrantedAuthority> authList=(List<GrantedAuthority>)jdbc.query(sql, new String[]{username},new RowMapper<GrantedAuthority>(){

			@Override
			public GrantedAuthority mapRow(ResultSet rs, int i)
					throws SQLException {
				return new GrantedAuthorityImpl(rs.getString("authority"));
			}
			
		});
		return authList;
	}
	
	
	

}
