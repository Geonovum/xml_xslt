<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:key name="owFile" match="file" use="name"/>
    <xsl:key name="bovenliggendeActiviteit" match="bovenliggendeActiviteitRelatie" use="bovenliggendeActiviteitIdLokaalAanwezig"/>
    <xsl:key name="gerelateerdeActiviteit" match="gerelateerdeActiviteitRelatie" use="gerelateerdeActiviteitIdLokaalAanwezig"/>
    <xsl:key name="RegelingId" match="Regeling" use="OrigineleregelingsFBRWork"/>
    <xsl:key name="HistorischInformatieobjectRef" match="historischInformatieobjectRef" use="oldIoRefId"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- The Muenchian Method is usually the best method to use for grouping nodes together from the XML source to your output 
        because it doesn't involve trawling through large numbers of nodes, and it's therefore more efficient. 
        http://www.jenitennison.com/xslt/grouping/muenchian.html
        https://stackoverflow.com/questions/10912544/removing-duplicate-elements-with-xslt
    -->
    <xsl:template match="file[not(generate-id() = generate-id(key('owFile', name)[1]))]">
    </xsl:template>
    <xsl:template match="bovenliggendeActiviteitRelatie[not(generate-id() = generate-id(key('bovenliggendeActiviteit', bovenliggendeActiviteitIdLokaalAanwezig)[1]))]">
    </xsl:template>
    <xsl:template match="gerelateerdeActiviteitRelatie[not(generate-id() = generate-id(key('gerelateerdeActiviteit', gerelateerdeActiviteitIdLokaalAanwezig)[1]))]">
    </xsl:template>
    <xsl:template match="Regeling[not(generate-id() = generate-id(key('RegelingId', OrigineleregelingsFBRWork)[1]))]">
    </xsl:template>
    <xsl:template match="historischInformatieobjectRef[not(generate-id() = generate-id(key('HistorischInformatieobjectRef', oldIoRefId)[1]))]">
    </xsl:template>
    
</xsl:stylesheet>