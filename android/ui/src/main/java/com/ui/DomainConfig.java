package com.ui;

import java.util.List;


public class DomainConfig {
    private String lastDomain;
    private String adImageUrl;
    private String adClickUrl;
    private Integer adCountdown;
    private String abUrl;
    private String userAgent;
    private List<String> domainList;
    private List<String> dnsApis;
    private List<String> configApis;
    private List<String> whiteList;


    public DomainConfig(String lastDomain, String adImageUrl, String adClickUrl, Integer adCountdown, String abUrl, String userAgent, List<String> domainList, List<String> dnsApis, List<String> configApis,List<String> whiteList) {
        this.lastDomain = lastDomain;
        this.adImageUrl = adImageUrl;
        this.adClickUrl = adClickUrl;
        this.adCountdown = adCountdown;
        this.abUrl = abUrl;
        this.userAgent = userAgent;
        this.domainList = domainList;
        this.dnsApis = dnsApis;
        this.configApis = configApis;
        this.whiteList = whiteList;
    }

    public String getLastDomain() {
        return lastDomain;
    }

    public void setLastDomain(String lastDomain) {
        this.lastDomain = lastDomain;
    }

    public String getAdImageUrl() {
        return adImageUrl;
    }

    public void setAdImageUrl(String adImageUrl) {
        this.adImageUrl = adImageUrl;
    }

    public String getAdClickUrl() {
        return adClickUrl;
    }

    public void setAdClickUrl(String adClickUrl) {
        this.adClickUrl = adClickUrl;
    }

    public Integer getAdCountdown() {
        return adCountdown;
    }

    public void setAdCountdown(Integer adCountdown) {
        this.adCountdown = adCountdown;
    }

    public String getAbUrl() {
        return abUrl;
    }

    public void setAbUrl(String abUrl) {
        this.abUrl = abUrl;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public List<String> getDomainList() {
        return domainList;
    }

    public void setDomainList(List<String> domainList) {
        this.domainList = domainList;
    }

    public List<String> getDnsApis() {
        return dnsApis;
    }

    public void setDnsApis(List<String> dnsApis) {
        this.dnsApis = dnsApis;
    }

    public List<String> getConfigApis() {
        return configApis;
    }

    public void setConfigApis(List<String> configApis) {
        this.configApis = configApis;
    }

    public List<String> getWhiteList() {
        return whiteList;
    }

    public void setWhiteList(List<String> whiteList) {
        this.whiteList = whiteList;
    }
}
