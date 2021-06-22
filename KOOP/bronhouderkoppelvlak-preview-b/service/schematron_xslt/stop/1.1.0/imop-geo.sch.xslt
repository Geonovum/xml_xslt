<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/"
                xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->
   <!--PROLOG-->
   <!--XSD TYPES FOR XSLT2-->
   <!--KEYS AND FUNCTIONS-->
   <!--DEFAULT RULES-->
   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <xsl:apply-templates select="/" mode="M6"/>
      <xsl:apply-templates select="/" mode="M7"/>
      <xsl:apply-templates select="/" mode="M8"/>
      <xsl:apply-templates select="/" mode="M9"/>
      <xsl:apply-templates select="/" mode="M10"/>
      <xsl:apply-templates select="/" mode="M11"/>
      <xsl:apply-templates select="/" mode="M12"/>
      <xsl:apply-templates select="/" mode="M13"/>
      <xsl:apply-templates select="/" mode="M14"/>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <!--PATTERN sch_geo_001Locatie rules-->
   <!--RULE -->
   <xsl:template match="geo:locaties" priority="1002" mode="M6">
      <xsl:variable name="aantalLocaties" select="count(./geo:Locatie)"/>
      <xsl:variable name="aantalLocatiesMetGroepID"
                    select="count(./geo:Locatie/geo:groepID)"/>
      <xsl:variable name="aantalLocatiesMetKwantitatieveNormwaarde"
                    select="count(./geo:Locatie/geo:kwantitatieveNormwaarde)"/>
      <xsl:variable name="aantalLocatiesMetKwalitatieveNormwaarde"
                    select="count(./geo:Locatie/geo:kwalitatieveNormwaarde)"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="($aantalLocatiesMetGroepID = 0) or ($aantalLocatiesMetGroepID = $aantalLocaties)"/>
         <xsl:otherwise>
        {"code": "STOP3000", "melding": "Als er één locatie is in een GIO waar een waarde groepID is ingevuld moet elke locatie een GroepID hebben. Geef alle locaties een groepID.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="($aantalLocatiesMetKwantitatieveNormwaarde = 0) or ($aantalLocatiesMetKwantitatieveNormwaarde = $aantalLocaties)"/>
         <xsl:otherwise>
        {"code": "STOP3006", "melding": "Een locatie heeft een kwantitatieveNormwaarde, en één of meerdere andere locaties niet. Geef alle locaties een kwantitatieveNormwaarde, of verwijder alle kwantitatieveNormwaardes.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="($aantalLocatiesMetKwalitatieveNormwaarde = 0) or ($aantalLocatiesMetKwalitatieveNormwaarde = $aantalLocaties)"/>
         <xsl:otherwise>
        {"code": "STOP3007", "melding": "Een locatie heeft een kwalitatieveNormwaarde, en één of meerdere andere locaties niet. Geef alle locaties een kwalitatieveNormwaarde, of verwijder alle kwalitatieveNormwaardes.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--REPORT fout-->
      <xsl:if test="(($aantalLocatiesMetKwantitatieveNormwaarde gt 0) and ((not(exists(../geo:eenheidlabel))) or (not(exists(../geo:eenheidID)))))">
        {"code": "STOP3009", "Work-ID": "<xsl:text/>
         <xsl:value-of select="../geo:FRBRWork"/>
         <xsl:text/>", "melding": "De locaties van de GIO <xsl:text/>
         <xsl:value-of select="../geo:FRBRWork"/>
         <xsl:text/> bevatten kwantitatieve normwaarden, terwijl eenheidlabel en/of eenheidID ontbreken. Vul deze aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="(($aantalLocatiesMetKwalitatieveNormwaarde gt 0) and ((exists(../geo:eenheidlabel) or exists(../geo:eenheidID))))">
        {"code": "STOP3015", "Work-ID": "<xsl:text/>
         <xsl:value-of select="../geo:FRBRWork"/>
         <xsl:text/>", "melding": "De GIO met Work-ID <xsl:text/>
         <xsl:value-of select="../geo:FRBRWork"/>
         <xsl:text/> met kwalitatieve normwaarden, mag geen eenheidlabel noch eenheidID hebben. Verwijder eenheidlabel en eenheidID toe, of verwijder de kwalitatieve normwaarden.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="((($aantalLocatiesMetKwantitatieveNormwaarde + $aantalLocatiesMetKwalitatieveNormwaarde) gt 0) and ((not(exists(../geo:normlabel))) or (not(exists(../geo:normID)))))">
        {"code": "STOP3011", "Work-ID": "<xsl:text/>
         <xsl:value-of select="../geo:FRBRWork"/>
         <xsl:text/>", "melding": "De locaties binnen GIO met Work-ID <xsl:text/>
         <xsl:value-of select="../geo:FRBRWork"/>
         <xsl:text/> bevatten wel kwantitatieve òf kwalitatieve normwaarden, maar geen norm. Vul normlabel en normID aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(./geo:Locatie/geo:geometrie/basisgeo:Geometrie/basisgeo:id) = count(distinct-values(./geo:Locatie/geo:geometrie/basisgeo:Geometrie/basisgeo:id))"/>
         <xsl:otherwise>
        {"code": "STOP3013", "Work-ID": "<xsl:text/>
            <xsl:value-of select="../geo:FRBRWork"/>
            <xsl:text/>", "melding": "In Work-ID <xsl:text/>
            <xsl:value-of select="../geo:FRBRWork"/>
            <xsl:text/> zijn de basisgeo:id's niet uniek. Binnen 1 GIO mag basisgeo:id van geometrieen van verschillende locaties niet gelijk zijn aan elkaar. Pas dit aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="geo:locaties/geo:Locatie" priority="1001" mode="M6">
      <xsl:variable name="ID" select="./geo:geometrie/basisgeo:Geometrie/basisgeo:id"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(./geo:kwantitatieveNormwaarde) + count(./geo:kwalitatieveNormwaarde) le 1"/>
         <xsl:otherwise>
        {"code": "STOP3008", "ID": "<xsl:text/>
            <xsl:value-of select="$ID"/>
            <xsl:text/>", "melding": "Locatie met basisgeo:id <xsl:text/>
            <xsl:value-of select="$ID"/>
            <xsl:text/> heeft zowel een kwalitatieveNormwaarde als een kwantitatieveNormwaarde. Verwijder één van beide.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--REPORT fout-->
      <xsl:if test="exists(./geo:groepID) and (exists(./geo:kwalitatieveNormwaarde) or exists(./geo:kwantitatieveNormwaarde))">
        {"code": "STOP3012", "ID": "<xsl:text/>
         <xsl:value-of select="$ID"/>
         <xsl:text/>", "melding": "Locatie met basisgeo:id <xsl:text/>
         <xsl:value-of select="$ID"/>
         <xsl:text/> heeft zowel een groepID (GIO-deel) als een (kwalitatieve of kwantitatieve) Normwaarde. Verwijder de Normwaarde of de groepID.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="geo:locaties/geo:Locatie/geo:kwalitatieveNormwaarde"
                 priority="1000"
                 mode="M6">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="normalize-space(.)"/>
         <xsl:otherwise>
        {"code": "STOP3010", "ID": "<xsl:text/>
            <xsl:value-of select="../geo:geometrie/basisgeo:Geometrie/basisgeo:id"/>
            <xsl:text/>", "melding": "De kwalitatieveNormwaarde van locatie met basisgeo:id <xsl:text/>
            <xsl:value-of select="../geo:geometrie/basisgeo:Geometrie/basisgeo:id"/>
            <xsl:text/> is niet gevuld. Vul deze aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <!--PATTERN sch_geo_002Als een locatie een groepID heeft, dan MOET deze voorkomen in het lijstje
      groepen.-->
   <!--RULE -->
   <xsl:template match="geo:Locatie/geo:groepID" priority="1000" mode="M7">
      <xsl:variable name="doelwit" select="./string()"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(../../../geo:groepen/geo:Groep[./geo:groepID = $doelwit]) gt 0"/>
         <xsl:otherwise>
        {"code": "STOP3001", "ID": "<xsl:text/>
            <xsl:value-of select="$doelwit"/>
            <xsl:text/>", "melding": "Als een locatie een groepID heeft, dan MOET deze voorkomen in het lijstje groepen. GroepID <xsl:text/>
            <xsl:value-of select="$doelwit"/>
            <xsl:text/> komt niet voor in groepen. Geef alle locaties een groepID die voorkomt in groepen.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <!--PATTERN sch_geo_003Als GroepID voorkomt mag het niet leeg zijn.-->
   <!--RULE -->
   <xsl:template match="geo:groepID" priority="1000" mode="M8">

		<!--REPORT fout-->
      <xsl:if test="normalize-space(./string()) = ''">
        {"code": "STOP3002", "melding": "Als GroepID voorkomt mag het niet leeg zijn. Geef een correcte groepID.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <!--PATTERN sch_geo_004Check op unieke labels en groepIDs.-->
   <!--RULE -->
   <xsl:template match="geo:groepen" priority="1000" mode="M9">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(./geo:Groep/geo:groepID) = count(distinct-values(./geo:Groep/geo:groepID))"/>
         <xsl:otherwise>
        {"code": "STOP3003", "melding": "Een groepID komt meerdere keren voor. Geef unieke groepIDs.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(./geo:Groep/geo:label) = count(distinct-values(./geo:Groep/geo:label))"/>
         <xsl:otherwise>
        {"code": "STOP3004", "melding": "Een label komt meerdere keren voor. Geef een unieke labels.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <!--PATTERN sch_geo_005Als een groepID voorkomt in het lijstje groepen dan MOET er minstens 1 locatie zijn
      met dat groepID.-->
   <!--RULE -->
   <xsl:template match="geo:groepen/geo:Groep/geo:groepID"
                 priority="1000"
                 mode="M10">
      <xsl:variable name="doelwit" select="./string()"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(../../../geo:locaties/geo:Locatie[./geo:groepID = $doelwit]) gt 0"/>
         <xsl:otherwise>
        {"code": "STOP3005", "ID": "<xsl:text/>
            <xsl:value-of select="$doelwit"/>
            <xsl:text/>", "melding": "GroepID <xsl:text/>
            <xsl:value-of select="$doelwit"/>
            <xsl:text/> wordt niet gebruikt voor een locatie. Verwijder deze groep, of gebruik de groep bij een Locatie.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <!--PATTERN sch_geo_006Geen norm elementen in een GIO zonder normwaarde.-->
   <!--RULE -->
   <xsl:template match="geo:GeoInformatieObjectVersie" priority="1000" mode="M11">

		<!--REPORT fout-->
      <xsl:if test="(exists(geo:normID) or exists(geo:normlabel) or exists(geo:eenheidID) or exists(geo:eenheidlabel)) and (count(geo:locaties/geo:Locatie/geo:kwantitatieveNormwaarde) + count(geo:locaties/geo:Locatie/geo:kwalitatieveNormwaarde) = 0)">
       {"code": "STOP3016", "Work-ID": "<xsl:text/>
         <xsl:value-of select="geo:FRBRWork"/>
         <xsl:text/>", "melding": "De GIO met Work-ID <xsl:text/>
         <xsl:value-of select="geo:FRBRWork"/>
         <xsl:text/> bevat norm (normID en normlabel) en/of eenheid (eenheidID en eenheidlabel), terwijl kwantitatieve of kwalitatieve normwaarden ontbreken. Geef de locaties normwaarden of verwijder de norm/eenheid elementen.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <!--PATTERN sch_basisgeo_001Locaties in een GIO MOETEN een geometrie hebben. (basisgeo:geometrie in
      basisgeo:Geometrie MAG NIET ontbreken of leeg zijn).-->
   <!--RULE -->
   <xsl:template match="basisgeo:geometrie" priority="1000" mode="M12">
      <xsl:variable name="coordinaten">
         <xsl:for-each xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
                       xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select=".//gml:posList | .//gml:pos | .//gml:coordinates">
            <xsl:value-of select="./string()"/>
            <xsl:text> </xsl:text>
         </xsl:for-each>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="(descendant::gml:pos or descendant::gml:posList or descendant::gml:coordinates) and matches($coordinaten, '\d')"/>
         <xsl:otherwise> 
        {"code": "STOP3019", "locatienaam": "<xsl:text/>
            <xsl:value-of select="ancestor::geo:Locatie/geo:naam"/>
            <xsl:text/>", "basisgeo:id": "<xsl:text/>
            <xsl:value-of select="preceding-sibling::basisgeo:id"/>
            <xsl:text/>", "ExpressieID": "<xsl:text/>
            <xsl:value-of select="ancestor::geo:GeoInformatieObjectVersie/geo:FRBRExpression"/>
            <xsl:text/>", "melding": "Een locatie(<xsl:text/>
            <xsl:value-of select="ancestor::geo:Locatie/geo:naam"/>
            <xsl:text/>) in de GIO(<xsl:text/>
            <xsl:value-of select="ancestor::geo:GeoInformatieObjectVersie/geo:FRBRExpression"/>
            <xsl:text/> heeft geen of een lege basisgeo:geometrie(<xsl:text/>
            <xsl:value-of select="preceding-sibling::basisgeo:id"/>
            <xsl:text/>). Een locatie zonder geometrie is niet toegestaan. Voeg een (correcte) basisgeo:geometrie toe.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M12"/>
   </xsl:template>
   <!--PATTERN sch_gml_001Coördinaten in geometrieen in een GIO MOETEN gebruik maken van het RD of ETRS89
      ruimtelijke referentiesysteem(srsName='urn:ogc:def:crs:EPSG::28992' of
      srsName='urn:ogc:def:crs:EPSG::4258').-->
   <!--RULE -->
   <xsl:template match="gml:*[@srsName]" priority="1000" mode="M13">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="@srsName = 'urn:ogc:def:crs:EPSG::28992' or @srsName = 'urn:ogc:def:crs:EPSG::4258'"/>
         <xsl:otherwise>
                    {"code": "STOP3020", "srsName": "<xsl:text/>
            <xsl:value-of select="@srsName"/>
            <xsl:text/>", "ExpressieID": "<xsl:text/>
            <xsl:value-of select="ancestor::geo:GeoInformatieObjectVersie/geo:FRBRExpression"/>
            <xsl:text/>", "melding": "De GIO(<xsl:text/>
            <xsl:value-of select="ancestor::geo:GeoInformatieObjectVersie/geo:FRBRExpression"/>
            <xsl:text/>) bevat een geometrie met een ongeldige srsName (<xsl:text/>
            <xsl:value-of select="@srsName"/>
            <xsl:text/>). Alleen srsName='urn:ogc:def:crs:EPSG::28992' of srsName='urn:ogc:def:crs:EPSG::4258' is toegestaan. Wijzig de srsName.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M13"/>
   </xsl:template>
   <!--PATTERN sch_gml_002Alle srsNames identiek-->
   <!--RULE -->
   <xsl:template match="geo:locaties" priority="1000" mode="M14">
      <xsl:variable name="srsName" select="//@srsName"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(distinct-values(//@srsName)) = 1"/>
         <xsl:otherwise>
        {"code": "STOP3021", "srsNames": "<xsl:text/>
            <xsl:value-of select="distinct-values($srsName)"/>
            <xsl:text/>", "ExpressieID": "<xsl:text/>
            <xsl:value-of select="ancestor::geo:GeoInformatieObjectVersie/geo:FRBRExpression"/>
            <xsl:text/>", "melding": "In GIO(<xsl:text/>
            <xsl:value-of select="ancestor::geo:GeoInformatieObjectVersie/geo:FRBRExpression"/>
            <xsl:text/>) heeft niet elke geometrie dezelfde srsName (<xsl:text/>
            <xsl:value-of select="distinct-values($srsName)"/>
            <xsl:text/>). Dit is niet toegestaan. Zorg ervoor dat elke geometrie in de GIO hetzelfde ruimtelijke referentiesysteem(srsName) gebruikt.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M14"/>
   </xsl:template>
</xsl:stylesheet>
