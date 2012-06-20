package com.samsong.erp.dao.basic;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

@Repository
public class ItemDAO {
	
	private JdbcTemplate jdbc;
	private SimpleJdbcCall sp;
	
	@Autowired
	public void setDataSource(DataSource ds){
		this.jdbc = new JdbcTemplate(ds);
		
	}

	public List<Map<String, Object>> getLocalizedItemList(Locale locale, String item, String cate, String localized) {
		String country = locale.getCountry();
		String sql = "exec ItemDAO_getLocalizedItemList ?,?,?,?;";
		return jdbc.queryForList(sql, country,item,cate,localized);
	}

	public void updateLocalItem(String item, String type, double p,
			String currency, String enabled, Locale locale) {
		String country = locale.getCountry();
		String sql = "exec ItemDAO_updateLocalItem ?,?,?,?,?,?;";
		jdbc.update(sql, item,type,p,currency,enabled,country);
	}

	public Map<String, Object> getLocalItemInfo(String item, Locale locale) {
		String country = locale.getCountry();
		String sql = "exec ItemDAO_getLocalItemInfo ?,?;";
		return jdbc.queryForMap(sql, item,country);
	}

	public List<Map<String, Object>> getLocalItemPricePerPartnerList(
			String item, Locale locale) {
		String country = locale.getCountry();
		String sql = "exec ItemDAO_getLocalItemPricePerPartnerList ?,?;";
		return jdbc.queryForList(sql, item,country);
	}

	public void updateLocalItemPrice(String action, String item,
			String partner, double price, String currency, String enabled,
			String username, Locale locale) {
		String country = locale.getCountry();
		String sql = "exec ItemDAO_updateLocalItemPrice ?,?,?,?,?,?,?,?;";
		jdbc.update(sql, action,item,partner,price,currency,enabled,username,country);
	}
	
	public List<Map<String,Object>> getEbomItemList(String type,String partCode,Locale locale,
			String car,String model){		
		String query = "exec ItemDAO_getEbomItemList ?,?,?,?,?";
		return jdbc.queryForList(query,type,partCode,locale.getCountry(),car,model);
	}
	
	public List<Map<String,Object>> getEbom(String partNo,Locale locale){
		String query = "exec [ItemDAO_getEbom] ?,?";
		return jdbc.queryForList(query,partNo,locale.getCountry());
	}
	
	public List<Map<String,Object>> getLocalPartList(Locale locale, String carType,String machineType,String partCode, String partType, String custCode, String supplier){
		String query = "exec [ItemDAO_getLocalPartList] ?,?,?,?,?,?,?";
		return jdbc.queryForList(query,new Object[]{locale.getCountry(),carType,machineType,partCode,partType,custCode,supplier});
	}
	
	public List<Map<String,Object>> getBasicOption(Locale locale, String type){
		String query = "";
		if(type.equals("CAR")){
			query = "select distinct car_type from dbo.master_part_local where locale = ? and isnull(car_type,'')<>'';";
			return jdbc.queryForList(query, new Object[]{locale.getCountry()});
		}
		else if(type.equals("MODEL")){
			query = "select distinct machine_type from dbo.master_part_local where locale = ? and isnull(machine_type,'')<>'';";
			return jdbc.queryForList(query, new Object[]{locale.getCountry()});
		}
		else if(type.equals("SUPPLIER")){
			query = "select cust_cd,cust_nm from ";
			query += " ( select distinct supplier From master_part_local where locale = ? )a";
			query += " left join ( select cust_cd,cust_nm from union_master_cust )b on a.supplier = b.cust_cd";
			return jdbc.queryForList(query, new Object[]{locale.getCountry()});
		}
		else if(type.equals("CUST")){
			query = "select cust_cd,cust_nm from ";
			query += " ( select  distinct cust_Code From master_part_local where locale = ? )a";
			query += " left join ( select cust_cd,cust_nm from union_master_cust )b on a.cust_Code = b.cust_cd";
			return jdbc.queryForList(query, new Object[]{locale.getCountry()});
		}
		else if(type.equals("COLOR")){
			query = "select distinct p_color from dbo.master_part_local where locale = ? and isnull(p_color,'')<>'';";
			return jdbc.queryForList(query, new Object[]{locale.getCountry()});
		}
		else if(type.equals("MATERQ")){
			query = "select distinct p_quality from dbo.master_part_local where locale = ? and isnull(p_quality,'')<>'';";
			return jdbc.queryForList(query, new Object[]{locale.getCountry()});
		}
		else if(type.equals("VESSEL")){
			query = "select distinct vessel_nm from dbo.master_part_local where locale = ? and isnull(vessel_nm,'')<>'';";
			return jdbc.queryForList(query, new Object[]{locale.getCountry()});
		}
		else if(type.equals("CUSTREG")){
			query = "select cust_cd,cust_nm from union_master_cust where locale = ? and cust_type = '1'";
			query +=" union select  cust_cd,cust_nm from union_master_cust where cust_cd = case(?) WHEN 'CN' THEN '911K' WHEN 'CZ' THEN 'C00053' WHEN 'IN' THEN 'C00035' END ";
			return jdbc.queryForList(query, new Object[]{locale.getCountry(),locale.getCountry()});
		}
		else if(type.equals("SUPPLIERREG")){
			query = "select cust_cd,cust_nm from union_master_cust where locale = ? and cust_type = '2'";
			query +=" union select  cust_cd,cust_nm from union_master_cust where cust_cd = case(?) WHEN 'CN' THEN '911K' WHEN 'CZ' THEN 'C00053' WHEN 'IN' THEN 'C00035' END ";
			return jdbc.queryForList(query, new Object[]{locale.getCountry(),locale.getCountry()});
		}
		else if(type.equals("ASSYCUSTREG")){
			query = "select cust_cd,cust_nm from union_master_cust where locale = ? and cust_type = '3'";
			query +=" union select  cust_cd,cust_nm from union_master_cust where cust_cd = case(?) WHEN 'CN' THEN '911K' WHEN 'CZ' THEN 'C00053' WHEN 'IN' THEN 'C00035' END ";
			return jdbc.queryForList(query, new Object[]{locale.getCountry(),locale.getCountry()});
		}
		else{
			return jdbc.queryForList(query, new Object[]{});
		}
	}
	
	
	public List<Map<String,Object>> getCodeCommonOption(Locale locale, String codeDiv){
		String query = "select * From code_common where locale =? and codediv = ?;";
		return jdbc.queryForList(query,new Object[]{locale.getCountry(),codeDiv});
	}
	
	public void prodLocalPartInfo(Locale locale, String prodType, String partType, String partNo,String classCd
			,String partName, String carType, String unit, String machineType, String pColor,String alcCode, String custCode
			,String prodCost,String prodCostType, String supplier,String supplyCost, String supplyCostType,String assyCust
			,String lineCode, String assyCost,String assyCostType, String pQuality,String pWeight,String boxQty,String pkgQty
			,String vesselName,String saftyDay,String remark,String user){
		
		String query = "exec [ItemDAO_prodLocalPartInfo] ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?;";
		jdbc.update(query, new Object[]{locale.getCountry(),prodType,partType,partNo,classCd
				,partName,carType,unit,machineType,pColor,alcCode,custCode,prodCost,prodCostType,supplier,supplyCost,supplyCostType
				,assyCust,lineCode,assyCost,assyCostType,pQuality,pWeight,boxQty,pkgQty,vesselName,saftyDay,remark,user});
		
	}
	public List<Map<String,Object>> getPartMasterInfo(Locale locale, String partNo){
		String query = "select * from master_part_local where locale = ? and part_no = ?";
		return jdbc.queryForList(query,new Object[]{locale.getCountry(),partNo});
	}
	
	public List<Map<String,Object>> getLineCode(Locale locale,String custCode){
		String query = "select b.cust_nm, line_code from ( select * from master_link_cust_line";
		query +=" where locale = ? and cust_code = case(?) when '' then cust_code else ? end";
		query +=" and use_yn = 'Y' )a left join ( select cust_cd,cust_nm from union_master_cust )b on a.cust_code = b.cust_cd";
		return jdbc.queryForList(query,new Object[]{locale.getCountry(),custCode,custCode});
	}
  
	
	
	
}
