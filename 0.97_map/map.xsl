<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:uuid="java.util.UUID"
    xmlns:gml="http://www.opengis.net/gml/3.2" exclude-result-prefixes="#all">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  
    <!-- make varible for mapping new elements of 97.1 -->
    <xsl:variable name="map">
        <element old="al" new="Al"/>
       
        <element old="Locatiegroep" new="Onbekend"/>
        <element old="Locaties" new="Onbekend"/>
       <!--
        <element old="OfficielePublicatie" new="Onbekend"/>
        
        <element old="Provincieblad" new="Onbekend"/>
        
       
        <element old="Tekst" new="Onbekend"/>
        -->
        <element old="tgroup" new="tgroup"/>
        <element old="thead" new="thead"/>
        <element old="title" new="title"/>
        <element old="Divisie" new="FormeleDivisie"/>
        <element old="Tussenkop" new="Tussenkop"/>
        <element old="Uitspraak" new="Uitspraak"/>
        <element old="Waarde" new="Waarde"/>
    </xsl:variable>
    
    <!-- Replace old elemnet with new one from variable $map -->    
    <xsl:template match="element()" priority="0">
        <xsl:variable name="name" select="name()" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$map/element[@old=$name]">
                <xsl:element name="{$map/element[@old=$name]/@new}">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{$name}">
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Delete elemnet Locatie -->
    <!--
    <xsl:template match="OfficielePublicatie/Locaties" priority="1">
    </xsl:template>
     -->
    <!-- Replace imop:objectRef to imop:Geometrie --> 
    <xsl:template match="@*">
        <xsl:choose>
            <xsl:when test=". eq 'imop:objectRef'">
                <xsl:attribute name="type" select="string('imop:Geometrie')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
   
    <!-- delete Tekst element -->
   
    <xsl:template match="Tekst">
        <xsl:apply-templates/>
    </xsl:template>
   
    
    <!-- Add namesapce for validation -->
    <xsl:template match="OfficielePublicatie" priority="1">
        <xsl:element name="Besluit">
            <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('https://standaarden.overheid.nl/stop/imop/ ./xsd_stop_0.97.1_imop_0.97.1.xsd')"/>
            <xsl:namespace name="gml" select="string('http://www.opengis.net/gml/3.2')"/>
            <xsl:namespace name="imop" select="string('https://standaarden.overheid.nl/stop/imop/')"/>
            <xsl:namespace name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
   
    <!-- Copy Gemotrie from Locaties to metadata as version 0.97 -->
    <!-- https://gitlab.com/koop/PR04/PR04-Overdracht/blob/master/voorbeeldbestanden/0.97.1u/Datacollecties/DatacollectiesEnInformatieObjecten.xml -->
    <xsl:variable name="werkingsgebiedID" select="fn:generate-id()"/>
    <xsl:variable name="Dateid"
        select="translate(substring(string(current-dateTime()), 1, 23), '-:T.', '')"/>
    
    
    <!-- create UUID -->
    <xsl:variable name="uuid" select="uuid:randomUUID()"/>
    
    <xsl:variable name="werkingsId" select="concat('/akn/nl/act/rws','_',$werkingsgebiedID, '/2018/bsl_', $uuid)"/>
    <xsl:variable name="werkingsIdDatum" select="concat($werkingsId,'@',$Dateid)"/>
    <xsl:variable name="oId" select="concat($uuid,'-',$Dateid)"/>
    
    
    <!-- 0.97.2 metdata  -->
    <xsl:template match="OfficielePublicatie/Metadata" priority="1">     
        <xsl:copy>
            <xsl:apply-templates/>
            <xsl:if test="OfficielePublicatie/Locaties/Geometrie">
            <xsl:element name="Uitspraak">
                <xsl:attribute name="eigenschap" select="string('imop:identificatie')"> 
                </xsl:attribute>
                <xsl:element name="Object">
                    <xsl:attribute name="type" select="string('imop:AKNIdentification')"/>              
                    <xsl:element name="Eigenschap">
                        <xsl:attribute name="naam" select="string('imop:FRBRWork')"/>
                        <xsl:element name="Object">
                            <xsl:attribute name="type" select="string('imop:FRBRWorkIdentification')"/>
                            <xsl:element name="Eigenschap">
                                <xsl:attribute name="naam" select="string('imop:FRBRthis')"/>
                                <xsl:element name="Waarde">
                                    <xsl:attribute name="type" select="string('xs:anyURI')"/>
                                    <xsl:value-of select="$werkingsId"/>
                                </xsl:element>
                            </xsl:element>
                            
                            <xsl:element name="Eigenschap">
                                <xsl:attribute name="naam" select="string('imop:FRBRuri')"/>
                                <xsl:element name="Waarde">
                                    <xsl:attribute name="type" select="string('xs:anyURI')"/>
                                    <xsl:value-of select="$werkingsId"/>
                                </xsl:element>
                            </xsl:element>
                            
                            
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Eigenschap">
                        <xsl:attribute name="naam" select="string('imop:FRBRExpression')"/>
                        <xsl:element name="Object">
                            <xsl:attribute name="type" select="string('imop:FRBRExpressionIdentification')"/>
                            <xsl:element name="Eigenschap">
                                <xsl:attribute name="naam" select="string('imop:FRBRthis')"/>
                                <xsl:element name="Waarde">
                                    <xsl:attribute name="type" select="string('xs:anyURI')"/>
                                    <xsl:value-of select="$werkingsIdDatum"/>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="Eigenschap">
                                <xsl:attribute name="naam" select="string('imop:FRBRuri')"/>
                                <xsl:element name="Waarde">
                                    <xsl:attribute name="type" select="string('xs:anyURI')"/>
                                    <xsl:value-of select="$werkingsIdDatum"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>  
                </xsl:element>             
            </xsl:element>
                       
            <xsl:element name="Uitspraak">
                <xsl:attribute name="eigenschap" select="string('imop:heeftDatacollectie')"> 
                </xsl:attribute> 
                <xsl:element name="Object">
                    <xsl:attribute name="type" select="string('imop:GeoInformatieobject')"/>                     
                    <xsl:element name="Eigenschap">
                        <xsl:attribute name="naam" select="string('imop:identificatie')"/> 
                        <xsl:element name="Object">
                            <xsl:attribute name="type" select="string('imop:JOINIdentification')"/>
                            <xsl:element name="Eigenschap">
                                <xsl:attribute name="naam" select="string('imop:FRBRWork')"/> 
                                <xsl:element name="Object">
                                    <xsl:attribute name="type" select="string('imop:FRBRWorkIdentification')"/>
                                    <xsl:element name="Eigenschap">
                                        <xsl:attribute name="naam" select="string('imop:FRBRthis')"/> 
                                        <xsl:element name="Waarde">
                                            <xsl:attribute name="type" select="string('xs:anyURI')"/>
                                            <xsl:value-of select="$werkingsId"/>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>                               
                            </xsl:element>                           
                            <xsl:element name="Eigenschap">
                                <xsl:attribute name="naam" select="string('imop:FRBRExpression')"/> 
                                <xsl:element name="Object">
                                    <xsl:attribute name="type" select="string('imop:FRBRExpressionIdentification')"/>
                                    <xsl:element name="Eigenschap">
                                        <xsl:attribute name="naam" select="string('imop:FRBRthis')"/> 
                                        <xsl:element name="Waarde">
                                            <xsl:attribute name="type" select="string('xs:anyURI')"/>
                                            <xsl:value-of select='$werkingsId'/>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>                               
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Eigenschap">
                        <xsl:attribute name="naam" select="string('imop:noemer')"/> 
                        <xsl:element name="Waarde">
                            <xsl:attribute name="type" select="string('xs:anyURI')"/>
                            Noemer_waarde
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Eigenschap">
                        <xsl:attribute name="naam" select="string('imop:collectieType')"/>
                        <xsl:element name="Waarde">
                            <xsl:attribute name="type" select="string('xs:anyURI')"/>
                            imop:Geometrie
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Eigenschap">
                        <xsl:attribute name="naam" select="string('imop:inhoud')"/> 
                        <xsl:element name="Object">
                            <xsl:attribute name="type" select="string('imop:Locatie')"/> 
                            <xsl:attribute name="oId" select="string($oId)"/> 
                            <xsl:element name="Eigenschap">
                               <xsl:attribute name="naam" select="string('imop:Geometrie')"/>                          
                                <xsl:element name="Geometrie">                          
                                    <xsl:apply-templates select="ancestor::OfficielePublicatie/Locaties/Geometrie/element()"/>
                                </xsl:element>    
                            </xsl:element>
                        </xsl:element>  
                     </xsl:element>                               
                </xsl:element>    
            </xsl:element> 
            </xsl:if>    
        </xsl:copy>
            
    </xsl:template>   
    
    <!-- Delete Waarde imop:Geometrie-->
    
    <xsl:template match="Metadata/Uitspraak[@eigenschap='imop:werkingsgebied']/Waarde"
        priority="1"> </xsl:template>
    <!-- add new Waarde imop:Geometrie-->
    <xsl:template match="@eigenschap">      
        <xsl:choose>
            <xsl:when test=". eq 'imop:werkingsgebied'">
                <xsl:copy/>
                <xsl:element name="Waarde">
                    <xsl:attribute name="type" select="string('imop:Geometrie')"/>
                    <xsl:value-of select="fn:string($werkingsId)"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>     
    </xsl:template>
    
    <!-- Add inline element to table|title  -->
    <xsl:template match="table/title" priority="1">
      <xsl:copy>   
         <xsl:element name="Inline">
             <xsl:apply-templates/>
         </xsl:element>
        </xsl:copy>   
    </xsl:template>
    
    <!-- 
    <xsl:copy>   
        <xsl:element name="inline">
            <xsl:value-of select="ancestor::table/title/text()"/>
        </xsl:element>
            <xsl:apply-templates/>    
    </xsl:copy>
    -->
    
    <!-- Replace element Provincieblad tree -->
    <xsl:template match="Provincieblad" priority="1">
        <xsl:element name="Regeling">
            <xsl:variable name="regelingId" select="fn:generate-id()"/>
            <xsl:attribute name="id" select="$regelingId"> </xsl:attribute>
            <xsl:element name="Lichaam">
                <xsl:element name="WijzigArtikel">
                    <xsl:element name="Metadata">
                        <xsl:element name="Uitspraak">
                            <xsl:attribute name="eigenschap" select="string('imop:datumInwerkingtreding')"/>
                            <xsl:element name="Waarde">
                                <xsl:attribute name="type" select="string('xs:date')"/>
                                <xsl:value-of select="ancestor::OfficielePublicatie/Metadata/Uitspraak[@eigenschap='imop:datumInwerkingtreding']/Waarde"/>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="Uitspraak">
                            <xsl:attribute name="eigenschap" select="string('imop:wijzigBijlage')"/>
                            <xsl:element name="Waarde">
                                <xsl:attribute name="type" select="string('xs:string')"/>
                                <xsl:value-of select="string('#cmp_1')"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Kop">
                        <xsl:element name="Label">
                            <xsl:text>Artikel</xsl:text>
                        </xsl:element>
                        <xsl:element name="Nummer">
                            <xsl:text>I</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Wat">
                        <xsl:value-of select="concat(ancestor::OfficielePublicatie/Metadata/Uitspraak[@eigenschap='imop:citeertitel']/Waarde,' wordt vastgesteld zoals vastgesteld in de bijlage.')"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Artikel">
                    <xsl:element name="Kop">
                        <xsl:element name="Label">
                            <xsl:text>Artikel</xsl:text>
                        </xsl:element>
                        <xsl:element name="Nummer">
                            <xsl:text>II</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="Inhoud">
                        <xsl:element name="Al">
                            <xsl:value-of select="concat('Dit OfficielePublicatie treedt in werking per ',ancestor::OfficielePublicatie/Metadata/Uitspraak[@eigenschap='imop:datumInwerkingtreding']/Waarde,'.')"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="WijzigBijlage">
                <!-- Waarde van imop:wordtVersie door AKN.xsl laten toevoegen -->
                <xsl:element name="Metadata">
                    <xsl:element name="Uitspraak">
                        <xsl:attribute name="eigenschap" select="string('imop:wordtVersie')"/>
                        <xsl:element name="Waarde">
                            <xsl:attribute name="type" select="string('xs:string')"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Kop">
                    <xsl:element name="Label">
                        <xsl:text>Bijlage</xsl:text>
                    </xsl:element>
                    <xsl:element name="Nummer">
                        <xsl:text>I</xsl:text>
                    </xsl:element>
                    <xsl:element name="Opschrift">
                        <xsl:text>Bijlage bij artikel I</xsl:text>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="MaakInitieleRegeling">
                    <xsl:element name="Lichaam">
                        <xsl:element name="FormeleDivisie">
                            <xsl:apply-templates/>     
                        </xsl:element>
                       
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <xsl:element name="Bijlage">
                <xsl:element name="Kop">
                    <xsl:element name="Label">Bijlage</xsl:element>
                    <xsl:element name="Nummer">I</xsl:element>
                    <xsl:element name="Opschrift">Overzicht informatieobjecten</xsl:element>
                 </xsl:element>
                <xsl:element name="Inhoud">
                    <xsl:element name="Begrippenlijst">
                        <xsl:element name="Begrip">
                            <xsl:element name="Term"> 
                                Werkinggebied A
                            </xsl:element>
                            <xsl:element name="Definitie">
                                <xsl:element name="Al">
                                    <xsl:element name="ExtIoRef">
                                        <xsl:attribute name="wId"/>
                                        <xsl:attribute name="eId"/>
                                        <xsl:attribute name="doel" select= "$werkingsId"/>                                     
                                        <xsl:value-of select="$werkingsId"/>                                     
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- Replace element Tekst/Divisiie to FoemeleDivisie -->
    <xsl:template match="Tekst/Divisie" priority="1">
        <xsl:element name="FormeleDivisie">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
 
    <!-- Replace element Divisiie|Inhoud to FoemeleInhoud -->
    <xsl:template match="Divisie/Inhoud" priority="1">
        <xsl:element name="FormeleInhoud">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- add attribute type to lijst -->
    <xsl:template match="Lijst" priority="1">      
        <xsl:copy>
            <xsl:attribute name="type">ongemarkeerd</xsl:attribute>
            <xsl:apply-templates select="@*"/>          
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- add attribute align to tgroup and entry -->
    <xsl:param name="alginelement" select="('tgroup','entry')"/>
    <xsl:template match="tgroup" priority="1">      
        <xsl:copy>
            <xsl:attribute name="align">left</xsl:attribute>
            <xsl:apply-templates select="@*"/>          
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="entry" priority="1">      
        <xsl:copy>
            <xsl:attribute name="align">left</xsl:attribute>
            <xsl:apply-templates select="@*"/>          
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- add attribute type to lijst -->
    
    <xsl:template match="thead" priority="1">      
        <xsl:copy>
            <xsl:attribute name="valign">top</xsl:attribute>
            <xsl:apply-templates select="@*"/>          
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- add attribute figgur and uitlijning,  remove attribute class form Illustratie -->
    
    <xsl:template match="Illustratie" priority="1">      
        <xsl:copy>
            <xsl:attribute name="formaat">jpeg</xsl:attribute>
            <xsl:attribute name="uitlijning">center</xsl:attribute>         
            <xsl:for-each select="@*">
                <xsl:if test="name() != 'class'">
                    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                </xsl:if> 
            </xsl:for-each>            
        </xsl:copy>
    </xsl:template>
    
    <!-- remove attribute tekstomloop and uitlijning form Figuur -->
    
    <xsl:template match="Figuur" priority="1">      
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:if test="name() != 'tekstomloop' and name() != 'uitlijning'">
                    <xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute>
                </xsl:if> 
            </xsl:for-each> 
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <!-- add attribute locatie to element Bijschrift -->
    <xsl:template match="Bijschrift" priority="1">      
            <xsl:copy>
                <xsl:attribute name="locatie">onder</xsl:attribute>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="@* | node()"/>
            </xsl:copy>
    </xsl:template>
    
    
    <!-- add attribute locatie to element Bijschrift -->
    <xsl:template match="ExtRef" priority="1">           
            <xsl:element name="{name()}">
                <xsl:attribute name="doel">
                  <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:element>   
    </xsl:template>
    
    <!-- Delete element tree Locatiegroep -->
    <xsl:template match="OfficielePublicatie/Locaties/Locatiegroep" priority="1">
    </xsl:template>
    
</xsl:stylesheet>