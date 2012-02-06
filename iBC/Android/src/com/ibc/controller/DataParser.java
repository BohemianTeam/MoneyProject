package com.ibc.controller;

import java.io.File;
import java.io.StringReader;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;

public class DataParser {

	private Document _doc = null;
	private JSONObject _root;
	
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
		} else {
			try {
				_root = new JSONObject(xml);
				return true;
			} catch (JSONException e) {
				return false;
			}
		}
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
}
