package com.samsong.erp.model;

import java.util.Collection;
import java.util.Locale;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

public class HanaroUser extends User {
	
	private Locale locale;

	public HanaroUser(String username, String password, boolean enabled,
			boolean accountNonExpired, boolean credentialsNonExpired,
			boolean accountNonLocked,Locale locale,
			Collection<? extends GrantedAuthority> authorities) {
		super(username, password, enabled, accountNonExpired, credentialsNonExpired,
				accountNonLocked, authorities);
		this.locale = locale;
	}
	
	public Locale getLocale(){
		return this.locale;
	}
	
	public void setLocale(Locale locale){
		this.locale = locale;
	}

	@Override
	public String toString() {
		return "HanaroUser [locale=" + locale + ", getAuthorities()="
				+ getAuthorities() + ", getPassword()=" + getPassword()
				+ ", getUsername()=" + getUsername() + ", isEnabled()="
				+ isEnabled() + ", isAccountNonExpired()="
				+ isAccountNonExpired() + ", isAccountNonLocked()="
				+ isAccountNonLocked() + ", isCredentialsNonExpired()="
				+ isCredentialsNonExpired() + ", hashCode()=" + hashCode()
				+ ", toString()=" + super.toString() + ", getClass()="
				+ getClass() + "]";
	}
	
	

}
