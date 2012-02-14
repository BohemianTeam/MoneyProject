package com.ibc.controller;

import java.io.File;
import java.io.StringReader;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.reflect.TypeToken;
import com.ibc.model.service.response.StatusResponse;
import com.ibc.model.service.response.VenueResponse;
import com.ibc.model.service.response.VenuesResponse;

public class DataParser {

	@SuppressWarnings("unused")
	private Document _doc = null;
	private JSONObject _root;
	private JSONArray _array;
	
	public DataParser() {

	}

	public boolean parse(String xml, DataType type) {
		if (type == DataType.XML) {
			try {
				_doc = parseDocument(xml);
				return true;
			} catch (Exception ex) {
				return false;
			}
		} else if (type == DataType.JSON){
			try {
				_root = new JSONObject(xml);
				return true;
			} catch (JSONException e) {
				try {
					_array = new JSONArray(xml);
					return true;
				} catch (JSONException e1) {
					return false;
				}
			}
		}
		return false;
	}

	public boolean parse(File file, DataType type) {
		if (type == DataType.XML) {
			try {
				_doc = parseFile(file);
				return true;
			} catch (Exception ex) {
				return false;
			}
		}
		return false;
	}

	private Document parseDocument(String xml) throws Exception {
		DocumentBuilderFactory builderFactory = DocumentBuilderFactory
				.newInstance();
		DocumentBuilder builder = builderFactory.newDocumentBuilder();
		Document doc = builder.parse(new InputSource(new StringReader(xml)));
		return doc;
	}
	
	private Document parseFile(File file) throws Exception {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = factory.newDocumentBuilder();
		Document doc = builder.parse(file);
		return doc;
	}
	
	/**
	 * Parser service response data methods
	 */
	public StatusResponse getStatusResponse() {
		if (_root == null) {
			return null;
		}
		StatusResponse response = new StatusResponse();
		try {
			response.setMindt(_root.getString("mindt"));
			response.setMaxdt(_root.getString("maxdt"));
			response.setAlertMsg(_root.getString("alert"));
			response.setAlertAct(_root.getString("alertaction"));
		} catch (JSONException e) {
			// TODO: handle exception
		}
		return response;
	}

	public List<VenuesResponse> getVenuesResponse(String result) {
		if (_root == null && _array == null) {
			return null;
		}
		Gson gson = new Gson();
		List<VenuesResponse> response = new ArrayList<VenuesResponse>();
		Type t = new TypeToken<List<VenuesResponse>>(){}.getType();
		response = gson.fromJson(result, t);
		/*
		for (int i = 0;i < _array.length();i++) {
			try {
				JSONObject element = _array.getJSONObject(i);
				VenuesResponse venues = gson.fromJson(element.toString(), VenuesResponse.class);
				response.add(venues);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		*/
		return response;
	}
	
	public VenueResponse getVenueResponse(String result) {
		if (_root == null && _array == null) {
			return null;
		}
		
		VenueResponse response = new VenueResponse();
		Gson gson = new Gson();
		gson.fromJson(result, VenueResponse.class);
		return response;
	}
}
