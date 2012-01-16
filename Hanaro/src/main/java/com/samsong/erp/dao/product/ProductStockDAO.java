package com.samsong.erp.dao.product;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.stereotype.Repository;

import com.samsong.erp.model.product.StockInOutSheet;

@Repository
public class ProductStockDAO {

	private JdbcTemplate jdbc;
	private SimpleJdbcCall sp;

	@Autowired
	public void init(DataSource ds){
		jdbc = new JdbcTemplate(ds);
	}
	
	public Map<String,Object> getComponentTypeOption(Locale locale,String type){
		final Map<String,Object> map =  new LinkedHashMap<String,Object>();
		String query = "select code, name from dbo.code_component_inout where locale = ? and inoutType = ? and useYn = 'Y';";
		jdbc.query(query, new Object[]{locale.getCountry(),type},new RowCallbackHandler() {			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				map.put(rs.getString(1),rs.getString(2));
				
			}
		});		
		return map;
	}
	
	public Map<String,Object> getLineCode(Locale locale){
		final Map<String,Object> map = new LinkedHashMap<String,Object>();
		String query = "select line_code from dbo.master_link_cust_line where locale = ? and use_yn = 'Y';";
		jdbc.query(query, new Object[]{locale.getCountry()},new RowCallbackHandler() {			
			@Override
			public void processRow(ResultSet rs) throws SQLException {
				map.put(rs.getString(1), rs.getString(1));
			}
		});
		return map;
	}
	
	public List<Map<String,Object>> getPartList(Locale locale, String type, String term){
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String query = "select  top 50 a.part_no,b.part_name from  ( select part_no from dbo.master_part where locale = ? and use_yn = 'Y'  and part_no like ?+'%' ";
		query+=" )a left join ( select part_no,part_name,part_type from part_master )b on a.part_no = b.part_no where part_type = ? order by part_no;";
		term = (term==null)?"":term;
		jdbc.query(query,new Object[]{locale.getCountry(),term,type}, new RowMapper<Map<String,Object>>(){
			@Override
			public Map<String, Object> mapRow(ResultSet rs, int idx)
					throws SQLException {				
				Map<String,Object> map = new LinkedHashMap<String,Object>();
				map.put("partCode",rs.getString(1));
				map.put("partName",rs.getString(2));
				list.add(map);
				return null;
			}		
		});
		return list;
	}
	
	public void prodIncomeOutgoList(Locale locale, String category, String pType,StockInOutSheet sheet,String user){
		SqlParameterSource param = new MapSqlParameterSource()
		.addValue("locate",locale.getCountry())
		.addValue("category",category)
		.addValue("pType",pType)
		.addValue("p1",sheet.getStdDt()).addValue("p2",sheet.getInoutType()).addValue("p3",sheet.getFromTo()).addValue("p4",sheet.getPartCode())
		.addValue("p5",sheet.getLotNo()).addValue("p6",sheet.getAmount()).addValue("p7",sheet.getComment()).addValue("seq",sheet.getSeq())
		.addValue("user",user);		
		sp = new SimpleJdbcCall(jdbc).withProcedureName("ProductStockDAO_prodIncomeOutgoList");
		sp.execute(param);		
	}
	
	public List<Map<String,Object>> getIncomeOutgoList(Locale locale, String category, String stdDt, String endDt){
		SqlParameterSource params = new MapSqlParameterSource()
		.addValue("locale",locale.getCountry())
		.addValue("category",category)
		.addValue("stdDt",stdDt)
		.addValue("endDt",endDt);
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		
		sp = new SimpleJdbcCall(jdbc).withProcedureName("ProductStockDAO_getIncomeOutgoList").returningResultSet("incomeList",new RowMapper<Map<String,Object>>() {
			@Override
			public Map<String, Object> mapRow(ResultSet rs, int idx)
					throws SQLException {
				Map<String,Object> m = new LinkedHashMap<String,Object>();
				for(int i = 0 ;i<rs.getMetaData().getColumnCount();i++){
					m.put("DATA"+i,rs.getString(i+1));					
				}
				list.add(m);
				return null;
			}
		});
		sp.execute(params);
		return list;
	}
	
}