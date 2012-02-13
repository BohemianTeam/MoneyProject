package com.ibc.model.service.response;

public class StatusResponse {
	private String _mindt;
	private String _maxdt;
	private String _alertMsg;
	private String _alertAct;
	public String getMindt() {
		return _mindt;
	}
	public void setMindt(String _mindt) {
		this._mindt = _mindt;
	}
	public String getMaxdt() {
		return _maxdt;
	}
	public void setMaxdt(String _maxdt) {
		this._maxdt = _maxdt;
	}
	public String getAlertMsg() {
		return _alertMsg;
	}
	public void setAlertMsg(String _alertMsg) {
		this._alertMsg = _alertMsg;
	}
	public String getAlertAct() {
		return _alertAct;
	}
	public void setAlertAct(String _alertAct) {
		this._alertAct = _alertAct;
	}
	
	
}
