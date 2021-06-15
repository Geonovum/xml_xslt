<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
                xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/"
                xmlns:cons="https://standaarden.overheid.nl/stop/imop/consolidatie/"
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
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <!--PATTERN sch_data_001AKN- of JOIN-identificatie mag geen punt bevatten-->
   <!--RULE -->
   <xsl:template match="*:FRBRWork | *:FRBRExpression | *:instrumentVersie | *:ExtIoRef | *:opvolgerVan | *:informatieobjectRef | *:instrument | *:heeftGeboorteregeling"
                 priority="1000"
                 mode="M6">

		<!--REPORT fout-->
      <xsl:if test="contains(., '.')">
        {"code": "STOP1000", "ID": "<xsl:text/>
         <xsl:value-of select="."/>
         <xsl:text/>", "melding": "De identifier <xsl:text/>
         <xsl:value-of select="."/>
         <xsl:text/> bevat een punt. Dit is niet toegestaan. Verwijder de punt.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
   </xsl:template>
   <!--PATTERN sch_data_002ExpressionID begint met WorkID-->
   <!--RULE -->
   <xsl:template match="*:ExpressionIdentificatie | geo:GeoInformatieObjectVersie "
                 priority="1000"
                 mode="M7">
      <xsl:variable name="Work" select="normalize-space(*:FRBRWork)"/>
      <xsl:variable name="Expression" select="normalize-space(*:FRBRExpression)"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="starts-with($Expression, concat($Work, '/'))"/>
         <xsl:otherwise>
        {"code": "STOP1001", "Work-ID": "<xsl:text/>
            <xsl:value-of select="$Work"/>
            <xsl:text/>", "Expression-ID": "<xsl:text/>
            <xsl:value-of select="$Expression"/>
            <xsl:text/>", "melding": "Het gedeelte van de FRBRExpression <xsl:text/>
            <xsl:value-of select="$Expression"/>
            <xsl:text/> vóór de 'taalcode/@' is niet gelijk aan de FRBRWork-identificatie <xsl:text/>
            <xsl:value-of select="$Work"/>
            <xsl:text/>.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
   </xsl:template>
   <!--PATTERN sch_data_003validatie van de eerste twee delen van de akn of join identificaties-->
   <!--RULE -->
   <xsl:template match="*:FRBRWork | *:FRBRExpression | *:instrumentVersie | *:ExtIoRef | *:opvolgerVan | *:informatieobjectRef | *:instrument | *:opvolgerVan"
                 priority="1000"
                 mode="M8">
      <xsl:variable name="Identificatie" select="./string()"/>
      <xsl:variable name="Identificatie_reeks" select="tokenize($Identificatie, '/')"/>
      <xsl:variable name="Identificatie_deel2" select="$Identificatie_reeks[3]"/>
      <xsl:variable name="land_expressie" select="'^(nl|aw|cw|sx)$'"/>
      <xsl:variable name="id_expressie" select="'^(id)$'"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="starts-with(./normalize-space(), '/akn/') or starts-with(./normalize-space(), '/join/')"/>
         <xsl:otherwise>
        {"code": "STOP1014", "ID": "<xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/>", "melding": "De waarde <xsl:text/>
            <xsl:value-of select="."/>
            <xsl:text/> begint niet met /akn/ of /join/. Pas de waarde aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--REPORT fout-->
      <xsl:if test="starts-with(./normalize-space(), '/akn/') and not(matches($Identificatie_deel2, $land_expressie))">
	    {"code": "STOP1002", "Work-ID": "<xsl:text/>
         <xsl:value-of select="./string()"/>
         <xsl:text/>", "substring": "<xsl:text/>
         <xsl:value-of select="$Identificatie_deel2"/>
         <xsl:text/>", "melding": "Landcode <xsl:text/>
         <xsl:value-of select="$Identificatie_deel2"/>
         <xsl:text/> in de AKN-identificatie <xsl:text/>
         <xsl:value-of select="./string()"/>
         <xsl:text/> is niet toegestaan. Pas landcode aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="starts-with(./normalize-space(), '/join/') and not(matches($Identificatie_deel2, $id_expressie))">
	    {"code": "STOP1003", "Work-ID": "<xsl:text/>
         <xsl:value-of select="./string()"/>
         <xsl:text/>", "melding": "Tweede deel JOIN-identificatie <xsl:text/>
         <xsl:value-of select="./string()"/>
         <xsl:text/> moet gelijk zijn aan 'id'. Pas dit aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M8"/>
   </xsl:template>
   <!--PATTERN sch_data_005AKN/JOIN validaties Expression/Work icm soortWork in ExpressionIdentificatie-->
   <!--RULE -->
   <xsl:template match="*:ExpressionIdentificatie" priority="1000" mode="M9">
      <xsl:variable name="soortWork" select="./*:soortWork/string()"/>
      <xsl:variable name="Expression" select="./*:FRBRExpression/string()"/>
      <xsl:variable name="Work" select="./*:FRBRWork/string()"/>
      <xsl:variable name="is_Expression" select="./*:FRBRExpression"/>
      <xsl:variable name="Expression_reeks" select="tokenize($Expression, '/')"/>
      <xsl:variable name="Expression_objecttype" select="$Expression_reeks[3]"/>
      <xsl:variable name="Expression_land" select="$Expression_reeks[3]"/>
      <xsl:variable name="Expression_collectie" select="$Expression_reeks[4]"/>
      <xsl:variable name="Expression_documenttype" select="$Expression_reeks[4]"/>
      <xsl:variable name="Expression_overheid" select="$Expression_reeks[5]"/>
      <xsl:variable name="Expression_datum_work" select="$Expression_reeks[6]"/>
      <xsl:variable name="Expression_restdeel" select="$Expression_reeks[8]"/>
      <xsl:variable name="Expression_restdeel_reeks"
                    select="tokenize($Expression_restdeel, '@')"/>
      <xsl:variable name="Expression_taal" select="$Expression_restdeel_reeks[1]"/>
      <xsl:variable name="Expression_restdeel_deel2" select="$Expression_restdeel_reeks[2]"/>
      <xsl:variable name="Expression_restdeel_deel2_reeks"
                    select="tokenize($Expression_restdeel_deel2, ';')"/>
      <xsl:variable name="Expression_datum_expr"
                    select="$Expression_restdeel_deel2_reeks[1]"/>
      <xsl:variable name="Work_reeks" select="tokenize($Work, '/')"/>
      <xsl:variable name="Work_objecttype" select="$Work_reeks[3]"/>
      <xsl:variable name="Work_land" select="$Work_reeks[3]"/>
      <xsl:variable name="Work_collectie" select="$Work_reeks[4]"/>
      <xsl:variable name="Work_documenttype" select="$Work_reeks[4]"/>
      <xsl:variable name="Work_overheid" select="$Work_reeks[5]"/>
      <xsl:variable name="Work_datum_work" select="$Work_reeks[6]"/>
      <xsl:variable name="is_besluit" select="$soortWork = '/join/id/stop/work_003'"/>
      <xsl:variable name="is_kennisgeving" select="$soortWork = '/join/id/stop/work_023'"/>
      <xsl:variable name="is_rectificatie" select="$soortWork = '/join/id/stop/work_018'"/>
      <xsl:variable name="is_tijdelijkregelingdeel"
                    select="$soortWork = '/join/id/stop/work_021'"/>
      <xsl:variable name="is_regeling"
                    select="$soortWork = '/join/id/stop/work_019' or $soortWork = '/join/id/stop/work_006' or $soortWork = '/join/id/stop/work_021' or $soortWork = '/join/id/stop/work_022'"/>
      <xsl:variable name="is_publicatie" select="$soortWork = '/join/id/stop/work_015'"/>
      <xsl:variable name="is_informatieobject"
                    select="$soortWork = '/join/id/stop/work_010'"/>
      <xsl:variable name="is_cons_informatieobject"
                    select="$soortWork = '/join/id/stop/work_005'"/>
      <xsl:variable name="overheidexpressie"
                    select="'^(mnre\d{4}|mn\d{3}|gm\d{4}|ws\d{4}|pv\d{2})$'"/>
      <xsl:variable name="bladcode" select="'^(bgr|gmb|prb|stb|stcrt|trb|wsb)$'"/>
      <xsl:variable name="taalexpressie" select="'^(nld|eng|fry|pap|mul|und)$'"/>
      <xsl:variable name="collectieexpressie" select="'^(regdata|infodata|pubdata)$'"/>
      <xsl:variable name="is_join" select="$is_informatieobject"/>
      <xsl:variable name="is_akn"
                    select="$is_besluit or $is_publicatie or $is_regeling or $is_kennisgeving or $is_rectificatie"/>
      <!--REPORT fout-->
      <xsl:if test="$is_publicatie and not(matches($Work_documenttype, '^officialGazette$'))">
	    {"code": "STOP1011", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "substring": "<xsl:text/>
         <xsl:value-of select="$Work_documenttype"/>
         <xsl:text/>", "melding": "Derde veld <xsl:text/>
         <xsl:value-of select="$Work_documenttype"/>
         <xsl:text/> in de AKN-identificatie <xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/> is niet toegestaan bij officiele publicatie. Pas dit veld aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="$is_besluit and not(matches($Work_documenttype, '^bill$'))">
	    {"code": "STOP1013", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "substring": "<xsl:text/>
         <xsl:value-of select="$Work_documenttype"/>
         <xsl:text/>", "melding": "Derde veld <xsl:text/>
         <xsl:value-of select="$Work_documenttype"/>
         <xsl:text/> in de AKN-identificatie <xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/> is niet toegestaan bij besluit. Pas dit veld aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="$is_regeling and not(matches($Work_documenttype, '^act$'))">
	    {"code": "STOP1012", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "substring": "<xsl:text/>
         <xsl:value-of select="$Work_documenttype"/>
         <xsl:text/>", "melding": "Derde veld <xsl:text/>
         <xsl:value-of select="$Work_documenttype"/>
         <xsl:text/> in de AKN-identificatie <xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/> is niet toegestaan bij regeling. Pas dit veld aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="$is_join and not(matches($Work_collectie, $collectieexpressie))">
	  	{"code": "STOP1004", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "melding": "Derde deel JOIN-identificatie <xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/> moet gelijk zijn aan regdata, pubdata, of infodata. Pas dit aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="($is_join or $is_akn) and not(($Work_datum_work castable as xs:date) or ($Work_datum_work castable as xs:gYear))">
		  {"code": "STOP1006", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "melding": "Vijfde deel AKN- of JOIN-identificatie <xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/> moet gelijk zijn aan jaartal of geldige datum. Pas dit aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="$is_join and not(($Expression_datum_expr castable as xs:date) or ($Expression_datum_expr castable as xs:gYear))">
		  {"code": "STOP1007", "Expression-ID": "<xsl:text/>
         <xsl:value-of select="$Expression"/>
         <xsl:text/>", "melding": "Voor een JOIN-identificatie (<xsl:text/>
         <xsl:value-of select="$Expression"/>
         <xsl:text/>) moet het eerste deel na de '@' een jaartal of een geldige datum zijn. Pas dit aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="$is_join and not($Expression_datum_expr &gt;= $Expression_datum_work)"> 
		  {"code": "STOP1008", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "Expression-ID": "<xsl:text/>
         <xsl:value-of select="$Expression"/>
         <xsl:text/>", "melding": "JOIN-identificatie (<xsl:text/>
         <xsl:value-of select="$Expression"/>
         <xsl:text/>) MOET als eerste deel na de '@' een jaartal of een geldige datum hebben groter/gelijk aan jaartal in werk (<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>). Pas dit aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="($is_join or $is_akn) and not(matches($Expression_taal, $taalexpressie))">
		  {"code": "STOP1009", "Expression-ID": "<xsl:text/>
         <xsl:value-of select="$Expression"/>
         <xsl:text/>", "substring": "<xsl:text/>
         <xsl:value-of select="$Expression_taal"/>
         <xsl:text/>", "melding": "Voor een AKN- of JOIN-identificatie (<xsl:text/>
         <xsl:value-of select="$Expression"/>
         <xsl:text/>) moet deel voorafgaand aan de '@' (<xsl:text/>
         <xsl:value-of select="$Expression_taal"/>
         <xsl:text/>) een geldige taal zijn ('nld','eng','fry','pap','mul','und'). Pas dit aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="($is_akn or $is_join) and not($is_publicatie) and          not(matches($Work_overheid, $overheidexpressie))">
		  {"code": "STOP1010", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "substring": "<xsl:text/>
         <xsl:value-of select="$Work_overheid"/>
         <xsl:text/>", "melding": "Vierde deel van AKN/JOIN van werk (<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>) moet gelijk zijn aan een brp-code. Pas (<xsl:text/>
         <xsl:value-of select="$Work_overheid"/>
         <xsl:text/>) aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="$is_publicatie and not(matches($Work_overheid, $bladcode))"> 
		  {"code": "STOP1017", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "substring": "<xsl:text/>
         <xsl:value-of select="$Work_overheid"/>
         <xsl:text/>", "melding": "Vierde veld <xsl:text/>
         <xsl:value-of select="$Work_overheid"/>
         <xsl:text/> in de AKN-identificatie <xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/> is niet toegestaan bij officiele publicatie. Pas dit veld aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="$is_kennisgeving and not(matches($Work_documenttype, '^doc$'))">
	    {"code": "STOP1037", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "substring": "<xsl:text/>
         <xsl:value-of select="$Work_documenttype"/>
         <xsl:text/>", "melding": "Derde veld <xsl:text/>
         <xsl:value-of select="$Work_documenttype"/>
         <xsl:text/> in de AKN-identificatie <xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/> is niet toegestaan voor een kennisgeving. Pas dit veld aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="$is_rectificatie and not(matches($Work_documenttype, '^doc$'))">
	    {"code": "STOP1044", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "substring": "<xsl:text/>
         <xsl:value-of select="$Work_documenttype"/>
         <xsl:text/>", "melding": "Derde deel <xsl:text/>
         <xsl:value-of select="$Work_documenttype"/>
         <xsl:text/> in de AKN-identificatie <xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/> is niet toegestaan voor een rectificatie. Pas dit deel aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="matches($Work_documenttype, '^bill$') and not($is_besluit)">
	    {"code": "STOP2002", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "soortWork": "<xsl:text/>
         <xsl:value-of select="$soortWork"/>
         <xsl:text/>", "melding": "FRBRWork '<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>' begint met '/akn/nl/bill/' maar soortwork'<xsl:text/>
         <xsl:value-of select="$soortWork"/>
         <xsl:text/>' is niet gelijk aan '/join/id/stop/work_003'(besluit).", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="matches($Work_documenttype, '^act$') and not($is_regeling)">
	    {"code": "STOP2003", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "soortWork": "<xsl:text/>
         <xsl:value-of select="$soortWork"/>
         <xsl:text/>", "melding": "FRBRWork '<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>' begint met '/akn/nl/act/' maar soortwork <xsl:text/>
         <xsl:value-of select="$soortWork"/>
         <xsl:text/>' is niet gelijk aan '/join/id/stop/work_019'(regeling), '/join/id/stop/work_006'(geconsolideerde regeling), '/join/id/stop/work_021'(tijdelijk regelingdeel) of '/join/id/stop/work_019'(consolidatie van tijdelijk regelingdeel).", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="matches($Work_documenttype, '^doc$') and not($is_rectificatie or $is_kennisgeving)">
	    {"code": "STOP2052", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "soortWork": "<xsl:text/>
         <xsl:value-of select="$soortWork"/>
         <xsl:text/>", "melding": "FRBRWork '<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>' begint met '/akn/nl/doc/' maar soortwork <xsl:text/>
         <xsl:value-of select="$soortWork"/>
         <xsl:text/>' is niet gelijk aan '/join/id/stop/work_018'(rectificatie) of '/join/id/stop/work_023'(kennisgeving).", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="(matches($Work_objecttype,'^id$')) and not($is_informatieobject or $is_cons_informatieobject)">
	    {"code": "STOP2024", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "soortWork": "<xsl:text/>
         <xsl:value-of select="$soortWork"/>
         <xsl:text/>", "melding": "FRBRWork '<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>' begint met '/join/id' maar soortwork <xsl:text/>
         <xsl:value-of select="$soortWork"/>
         <xsl:text/>' is niet gelijk aan '/join/id/stop/work_010'(informatieobject) of '/join/id/stop/work_005'(geconsolideerd informatieobject).", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="$is_tijdelijkregelingdeel and not(./data:isTijdelijkDeelVan)">
	    {"code": "STOP2058", "Work-ID": "<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>", "melding": "De ExpressionIdentificatie('<xsl:text/>
         <xsl:value-of select="$Work"/>
         <xsl:text/>') is van een tijdelijk regelingdeel (data:soortWork = '/join/id/stop/work_021') maar deze geeft niet aan van welke regeling het een tijdelijk deel is. Voeg data:isTijdelijkDeelVan toe.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M9"/>
   </xsl:template>
   <!--PATTERN sch_data_006Tijdelijk regelingdeel-->
   <!--RULE -->
   <xsl:template match="data:isTijdelijkDeelVan" priority="1000" mode="M10">
      <xsl:variable name="soortWork" select="../data:soortWork/string()"/>
      <xsl:variable name="soortWorkTijdelijkDeel"
                    select="./data:WorkIdentificatie/data:soortWork/string()"/>
      <xsl:variable name="WorkTijdelijkDeel"
                    select="./data:WorkIdentificatie/data:FRBRWork/string()"/>
      <xsl:variable name="WorkTijdelijkDeel_reeks"
                    select="tokenize($WorkTijdelijkDeel, '/')"/>
      <xsl:variable name="WorkTijdelijkDeel_documenttype"
                    select="$WorkTijdelijkDeel_reeks[4]"/>
      <xsl:variable name="is_tijdelijkregelingdeel"
                    select="$soortWork = '/join/id/stop/work_021'"/>
      <xsl:variable name="TijdelijkDeel_is_regeling"
                    select="$soortWorkTijdelijkDeel = '/join/id/stop/work_019'"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$is_tijdelijkregelingdeel"/>
         <xsl:otherwise>
        {"code": "STOP2004", "soortWork": "<xsl:text/>
            <xsl:value-of select="$soortWork"/>
            <xsl:text/>", "melding": "De ExpressionIdentificatie bevat data:isTijdelijkDeelVan, maar data:soortWork('<xsl:text/>
            <xsl:value-of select="$soortWork"/>
            <xsl:text/>') is niet gelijk aan '/join/id/stop/work_021'(tijdelijk regelingdeel). Pas soortWork aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="matches($WorkTijdelijkDeel_documenttype, '^act$')"/>
         <xsl:otherwise>
        {"code": "STOP2054", "Work-ID": "<xsl:text/>
            <xsl:value-of select="$WorkTijdelijkDeel"/>
            <xsl:text/>", "melding": "De ExpressionIdentificatie bevat data:isTijdelijkDeelVan, maar is geen tijdelijk deel van een FRBRWork('<xsl:text/>
            <xsl:value-of select="$WorkTijdelijkDeel"/>
            <xsl:text/>') met als derde deel '/act/'. Pas FRBRWork aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$TijdelijkDeel_is_regeling"/>
         <xsl:otherwise>
        {"code": "STOP2057", "soortWork": "<xsl:text/>
            <xsl:value-of select="$soortWorkTijdelijkDeel"/>
            <xsl:text/>", "melding": "De ExpressionIdentificatie bevat data:isTijdelijkDeelVan, maar het soortWork('<xsl:text/>
            <xsl:value-of select="$soortWorkTijdelijkDeel"/>
            <xsl:text/>') van de regeling waar deze regeling een tijdelijk deel van is, is niet gelijk aan '/join/id/stop/work_019' (regeling). Pas soortWork aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M10"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="cons:doel | data:doel" priority="1000" mode="M11">
      <xsl:variable name="hetDoel"
                    select="substring-after(normalize-space(./string()), '/')"/>
      <xsl:variable name="doelDelen" select="tokenize($hetDoel, '/')"/>
      <xsl:variable name="resultaat">
         <xsl:if xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                 test="not($doelDelen[1] = 'join')">'<xsl:value-of select="$doelDelen[1]"/>' moet
          zijn 'join', </xsl:if>
         <xsl:if xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                 test="not($doelDelen[2] = 'id')">'<xsl:value-of select="$doelDelen[2]"/>' moet zijn
          'id', </xsl:if>
         <xsl:if xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                 test="not($doelDelen[3] = 'proces')">'<xsl:value-of select="$doelDelen[3]"/>' moet
          zijn 'proces', </xsl:if>
         <xsl:if xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                 test="not(matches($doelDelen[4], '^(mnre\d{4}|mn\d{3}|gm\d{4}|ws\d{4}|pv\d{2})'))">'<xsl:value-of select="$doelDelen[4]"/>' is geen geldige code, </xsl:if>
         <xsl:if xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                 test="not(($doelDelen[5] castable as xs:date) or ($doelDelen[5] castable as xs:gYear)) or not((string-length($doelDelen[5]) = 4) or (string-length($doelDelen[5]) = 10))">'<xsl:value-of select="$doelDelen[5]"/>' is geen geldige datum, </xsl:if>
         <xsl:if xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                 xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                 test="not(matches($doelDelen[6], '^[a-zA-Z0-9][a-zA-Z0-9_-]*$'))">'<xsl:value-of select="$doelDelen[6]"/>' is geen correcte naam voor een doel, </xsl:if>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$resultaat = ''"/>
         <xsl:otherwise>{"code": "STOP1038", "resultaat": "<xsl:text/>
            <xsl:value-of select="normalize-space($resultaat)"/>
            <xsl:text/>", "melding": "De identificatie voor doel is niet correct: <xsl:text/>
            <xsl:value-of select="normalize-space($resultaat)"/>
            <xsl:text/> corrigeer de identificatie voor doel.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*|comment()|processing-instruction()" mode="M11"/>
   </xsl:template>
</xsl:stylesheet>
