package com.samsong.erp.dao.product;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BatchPreparedStatementSetter;
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
	
	public List<Map<String,Object>> getSubOptionByInoutComponent(Locale locale, String code){
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		SqlParameterSource param = new MapSqlParameterSource().addValue("locale",locale.getCountry()).addValue("code",code);
		sp = new SimpleJdbcCall(jdbc).withProcedureName("ProductStockDAO_getSubOptionByInoutComponent").returningResultSet("subOptions",new RowMapper<Map<String,Object>>() {
			@Override
			public Map<String, Object> mapRow(ResultSet rs, int idx)
					throws SQLException {
				Map<String,Object> m = new LinkedHashMap<String,Object>();
				m.put("code",rs.getString(1));
				m.put("name",rs.getString(2));
				list.add(m);
				return null;
			}
			
		});
		sp.execute(param);
		return list;
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
	
	public void prodIncomeOutgoList(final Locale locale, String category
			,final String[] DATA0,final String[] DATA1,final String[] DATA2,final String[] DATA3,final String[] DATA4
			,final String[] DATA5,final String[] DATA6,final String[] DATA7,final String[] DATA8,final String[] DATA9
			,final String[] DATA10,final String[] DATA11,final String[] DATA12,final String user){
		
		if (category.equals("income")){
			if(DATA0!=null){
				String sqlDelete = "delete from [product_stock_income] WHERE seq = ?";			
				jdbc.batchUpdate(sqlDelete, new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						ps.setString(1, DATA0[i]);					
					}
	
					@Override
					public int getBatchSize() {
						return DATA0.length;
					}
				});
				String sqlInsert = "INSERT INTO [product_stock_income]";
				sqlInsert+="  ([locale],[stdDt],[inoutType],[fromLine],[partCode],[lotNo],[amount],[comment],[inputBy],[inputDt],[deleted])";
				sqlInsert+=" VALUES(?,?,?,?,?,?,?,?,?,getdate(),'N')";
				for(int i=0;i<DATA1.length;i++){
				if (DATA9[i].equals("DELETE"))
					continue;
				jdbc.update(
						sqlInsert,
						new Object[] { locale.getCountry(),  DATA1[i],DATA11[i],DATA3[i],
								DATA4[i],(DATA6.length==0)?"":DATA6[i],DATA7[i],(DATA8.length==0)?"":DATA8[i],user});
				}
				
				
			}
		}else if(category.equals("outgo")){
			
			if(DATA0!=null){
				String sqlDelete = "delete from [product_stock_outgo] WHERE seq = ?";			
				jdbc.batchUpdate(sqlDelete, new BatchPreparedStatementSetter() {
					@Override
					public void setValues(PreparedStatement ps, int i)
							throws SQLException {
						ps.setString(1, DATA0[i]);					
					}
	
					@Override
					public int getBatchSize() {
						return DATA0.length;
					}
				});
				
				String sqlInsert = "INSERT INTO [product_stock_outgo]";
				sqlInsert+="  ([locale],[stdDt],[inoutType],[toCust],[partCode],[lotNo],[amount],[comment],[inputBy],[inputDt],[deleted])";
				sqlInsert+=" VALUES(?,?,?,?,?,?,?,?,?,getdate(),'N')";
				
				for(int i=0;i<DATA1.length;i++){
				if (DATA9[i].equals("DELETE"))
					continue;
				
				jdbc.update(
						sqlInsert,
						new Object[] { locale.getCountry(),  DATA1[i],DATA12[i],DATA11[i],
								DATA4[i], (DATA6.length==0)?"":DATA6[i],DATA7[i],(DATA8.length==0)?"":DATA8[i],user});
				
				}
									
			}			
		}
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
					if(i==7)
						m.put("DATA"+i,rs.getLong(i+1));
					else
						m.put("DATA"+i,rs.getString(i+1));					
				}
				list.add(m);
				return null;
			}
		});
		sp.execute(params);
		return list;
	}
	
	public List<Map<String,Object>> getIncomeOutgoState(Locale locale,String partCode,String stdDt,String endDt,String inoutYn,String fromToYn){
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		SqlParameterSource params = new MapSqlParameterSource()
		.addValue("locale",locale.getCountry())
		.addValue("partCode",partCode)
		.addValue("stdDt",stdDt)
		.addValue("endDt",endDt)
		.addValue("inOutYn",inoutYn)
		.addValue("fromToYn",fromToYn);
		sp = new SimpleJdbcCall(jdbc).withProcedureName("ProductStockDAO_getIncomeOutgoState").returningResultSet("productinoutState",new RowMapper<Map<String,Object>>() {

		int crtAmount = 0;
			@Override
			public Map<String, Object> mapRow(ResultSet rs, int idx)
					throws SQLException {
				Map<String,Object> m = new LinkedHashMap<String,Object>();
				for(int i=0;i<rs.getMetaData().getColumnCount();i++)
					m.put("DATA"+i,rs.getString(1+i));
				crtAmount = crtAmount+rs.getInt(rs.getMetaData().getColumnCount());
				m.put("DATA"+rs.getMetaData().getColumnCount(),crtAmount);
				list.add(m);
				return null;
			}
			
		});
		
		sp.execute(params);
		return list;
	}
	
	public List<Map<String,Object>> getComponentHead(Locale locale,String type){
		String query = "select code,name from code_component_inout where locale = ? and left(inoutType,1) = ? order by inoutType desc,right(code,2) asc;";
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();		
		jdbc.query(query,new Object[]{locale.getCountry(),type},new RowMapper<Map<String,Object>>(){
			@Override
			public Map<String, Object> mapRow(ResultSet rs, int idx)
					throws SQLException {
				Map<String,Object> m = new LinkedHashMap<String,Object>();
				m.put("code",rs.getString(1));
				m.put("name",rs.getString(2));
				list.add(m);
				return null;
			}			
		});
		return list;
		
	}
	
	public String getCheckPreCloseData(Locale locale,String year,String month){
		String query = "if exists (select * from product_stock_actual where stdDt = convert(nvarchar(10),dateadd(month,-1,?+'-'+right('0'+?,2)+'-01'),121) and locale = ?) select 'YES' else select 'NO';";
		return jdbc.queryForObject(query, new Object[]{year,month,locale.getCountry()},new RowMapper<String>(){
			@Override
			public String mapRow(ResultSet rs, int idx) throws SQLException {
				return rs.getString(1);
			}
		});
	}
	
	public String getCheckThisCloseData(Locale locale,String year,String month){
		String query = "if exists (select * from product_stock_close where stdDt = ?+'-'+right('0'+?,2)+'-01' and locale = ?) select 'YES' else select 'NO';";
		return jdbc.queryForObject(query, new Object[]{year,month,locale.getCountry()},new RowMapper<String>(){
			@Override
			public String mapRow(ResultSet rs, int idx) throws SQLException {
				return rs.getString(1);
			}
		});
	}
	
	public List<Map<String,Object>> prodApplyCloseData(Locale locale,String type, String year, String month, String user){
		final List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		SqlParameterSource params = new MapSqlParameterSource()
		.addValue("locale",locale.getCountry())
		.addValue("type",type)
		.addValue("year",year)
		.addValue("month",month)
		.addValue("user",user);		
		sp = new SimpleJdbcCall(jdbc).withProcedureName("ProductStockDAO_prodApplyCloseData").returningResultSet("closeList",new RowMapper<Map<String,Object>>() {
			@Override
			public Map<String, Object> mapRow(ResultSet rs, int idx)
					throws SQLException {
				Map<String,Object> m = new LinkedHashMap<String,Object>();
				for(int x=0;x<rs.getMetaData().getColumnCount();x++){
					if (x==0)
						m.put("DATA"+x,rs.getString(1));
					else if (x==14)
						m.put("DATA"+x,rs.getString(15));
					else
						m.put("DATA"+x,rs.getLong(x+1));
				}
				list.add(m);
				return null;
			}
		});
		sp.execute(params);
		return list;
	}
	
	
	public void prodApplyActualData(final Locale locale,final String[] stdDt,final String[] partCode,final String[] amount, final String user){
		if(stdDt!=null){
			String sqlDelete = "delete from [product_stock_actual] WHERE stdDt = ? and locale = ?";
			jdbc.update(sqlDelete,new Object[]{stdDt[0],locale.getCountry()});
			System.out.println(stdDt[0]);
			System.out.println(partCode[0]);
			System.out.println(amount[0]);
			
			String sqlInsert = "insert into product_stock_actual (locale,stdDt,partCode,amount,inputBy,inputDt) values(?,?,?,?,?,getdate());";
			jdbc.batchUpdate(sqlInsert, new BatchPreparedStatementSetter() {
				@Override
				public void setValues(PreparedStatement ps, int i)
						throws SQLException {
					ps.setString(1, locale.getCountry());
					ps.setString(2, stdDt[0]);
					ps.setString(3, partCode[i]);
					ps.setString(4, amount[i]);
					ps.setString(5, user);
				}

				@Override
				public int getBatchSize() {
					return stdDt.length;
				}
			});
		}
		
	}
	
	
	
	
	
}
