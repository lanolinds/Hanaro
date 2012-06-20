package com.samsong.erp.ctrl.basic;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.samsong.erp.model.HanaroUser;
import com.samsong.erp.service.basic.ItemService;
import com.samsong.erp.util.HashMapComparator;

@Controller
@RequestMapping(value="/basicDivision/items")
public class LocalItemManagerController {
	private static final Logger logger = Logger.getLogger(LocalItemManagerController.class);
	private String prefix = "/basicDivision/items";
	
	@Autowired
	private ItemService service;
	
	
	
	@RequestMapping(value="/localItemManager",method=RequestMethod.GET)
	public String menuLocalItem(Model model,Authentication auth){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		List<Map<String,Object>> listCar = service.getBasicOption(user.getLocale(), "CAR");
		List<Map<String,Object>> listModel = service.getBasicOption(user.getLocale(), "MODEL");
		List<Map<String,Object>> listCust = service.getBasicOption(user.getLocale(), "CUST");		
		List<Map<String,Object>> listSupplier = service.getBasicOption(user.getLocale(), "SUPPLIER");
		List<Map<String,Object>> listColor = service.getBasicOption(user.getLocale(), "COLOR");
		List<Map<String,Object>> listVessel = service.getBasicOption(user.getLocale(), "VESSEL");
		List<Map<String,Object>> listMaterQuality = service.getBasicOption(user.getLocale(), "MATERQ");
		List<Map<String,Object>> listCustReg = service.getBasicOption(user.getLocale(), "CUSTREG");
		List<Map<String,Object>> listSupplierReg = service.getBasicOption(user.getLocale(), "SUPPLIERREG");
		List<Map<String,Object>> listAssyCustReg = service.getBasicOption(user.getLocale(), "ASSYCUSTREG");
		
		
		List<Map<String,Object>> listPartType = service.getCodeCommonOption(user.getLocale(),"PARTTYPE");
		List<Map<String,Object>> listProductType = service.getCodeCommonOption(user.getLocale(),"PRODUCTTYPE");
		List<Map<String,Object>> listUnit = service.getCodeCommonOption(user.getLocale(),"UNIT");
		List<Map<String,Object>> listCostType = service.getCodeCommonOption(user.getLocale(),"COSTTYPE");
		
		
		model.addAttribute("costTypeList",listCostType);
		model.addAttribute("custRegList",listCustReg);
		model.addAttribute("supplierRegList",listSupplierReg);
		model.addAttribute("assyCustRegList",listAssyCustReg);
		model.addAttribute("vessel",listVessel);
		model.addAttribute("materQuality",listMaterQuality);
		model.addAttribute("colorList",listColor);
		model.addAttribute("unitList",listUnit);
		model.addAttribute("productType",listProductType);
		model.addAttribute("partType",listPartType);
		model.addAttribute("carList",listCar);
		model.addAttribute("modelList",listModel);
		model.addAttribute("custList",listCust);
		model.addAttribute("supplierList",listSupplier);
		
		return prefix+"/localItemManager";
	}
	
	@RequestMapping(value="/getLocalPartList", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object> getCustRegList(Authentication auth,
			@RequestParam(value="carType",required=false) String carType,
			@RequestParam(value="machineType",required=false) String machineType,
			@RequestParam(value="partCode",required=false) String partCode,
			@RequestParam(value="partType",required=false) String partType,
			@RequestParam(value="custCode",required=false) String custCode,
			@RequestParam(value="supplierCode",required=false) String supplierCode,					
			
			@RequestParam(value="sort",required=false) String sortKey,
			@RequestParam(value="order",required=false) String order){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		Map<String,Object> table = new LinkedHashMap<String,Object>();
		List<Map<String,Object>> resultList = service.getLocalPartList(user.getLocale(), carType, machineType, partCode, partType, custCode, supplierCode);
	
		if(resultList!=null){			
			if(sortKey!=null){
				Collections.sort(resultList,new HashMapComparator(sortKey, order.equalsIgnoreCase("asc")));
			}
			
			table.put("total",resultList.size());
			table.put("rows",resultList);
		}else{
			table.put("total",0);
		}
		return table;
	}
	
	@RequestMapping(value="/localItemManager",method = RequestMethod.POST)
	public String prodLocalPartInfo(Authentication auth,
			@RequestParam(value="prodType") String prodType,
			@RequestParam(value="selCateList",required=false)String partType,
			@RequestParam(value="partNo1",required=false)String partNo1,
			@RequestParam(value="partNo2",required=false)String partNo2,
			@RequestParam(value="selProductTypeList",required=false)String classCd,
			@RequestParam(value="partNm",required=false)String partName,
			@RequestParam(value="selCarTypeList",required=false)String carType,
			@RequestParam(value="selUnitList",required=false)String unit,
			@RequestParam(value="selMachineTypeList",required=false)String machineType,
			@RequestParam(value="selColorList",required=false)String pColor,
			@RequestParam(value="alcCode",required=false)String alcCode,
			@RequestParam(value="selCustRegList",required=false)String custCode,
			@RequestParam(value="txtProdCost",required=false)String prodCost,
			@RequestParam(value="selCustCostTypeList",required=false)String prodCostType,
			@RequestParam(value="selSupplierRegList",required=false)String supplier,
			@RequestParam(value="txtSupplyCost",required=false)String supplyCost,
			@RequestParam(value="selSupplyCostTypeList",required=false)String supplyCostType,
			@RequestParam(value="selAssyCustRegList",required=false)String assyCust,
			@RequestParam(value="selLineCodeList",required=false)String lineCode,
			@RequestParam(value="txtAssyCost",required=false)String assyCost,
			@RequestParam(value="selAssyCostTypeList",required=false)String assyCostType,
			@RequestParam(value="selRawMaterList",required=false)String pQuality,
			@RequestParam(value="txtWeight",required=false)String pWeight,
			@RequestParam(value="txtBoxQty",required=false)String boxQty,
			@RequestParam(value="txtPackQty",required=false)String pkgQty,
			@RequestParam(value="selVesselList",required=false)String vesselName,
			@RequestParam(value="txtSaftyDay",required=false)String saftyDay,
			@RequestParam(value="remark",required=false)String remark){		
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		service.prodLocalPartInfo(user.getLocale(), prodType, partType, partNo1+"-"+partNo2,
				classCd, partName, carType, unit, machineType, pColor, alcCode, custCode,
				prodCost, prodCostType, supplier, supplyCost, supplyCostType
				,(assyCust==null)?"":assyCust
				,(lineCode==null)?"":lineCode
				,(assyCost==null)?"0.00":assyCost
				,(assyCostType==null)?"3":assyCostType
				,pQuality, pWeight, boxQty, pkgQty,
				vesselName, saftyDay, remark, user.getUsername());
		return "redirect:"+prefix+"/localItemManager";		
	}
	
	@RequestMapping(value="/getPartMasterInfo",method=RequestMethod.GET)
	public @ResponseBody List<Map<String,Object>> getPartMasterInfo(Authentication auth,
			@RequestParam(value="partNo") String partNo){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getPartMasterInfo(user.getLocale(), partNo);
	}
	
	@RequestMapping(value="/getLineCodeOption",method=RequestMethod.GET)
	public @ResponseBody List<Map<String,Object>> getLineCodeOption(Authentication auth,
			@RequestParam(value="custCode") String custCode){
		HanaroUser user = (HanaroUser)auth.getPrincipal();
		return service.getLineCode(user.getLocale(), custCode);
	}
	
	
	
	

}
