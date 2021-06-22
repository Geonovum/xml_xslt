<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
                xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
                xmlns:lvbba="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
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
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <!--PATTERN sch_lvbba_BHKV1014Informatieobject - aanleveren GIO-->
   <!--RULE -->
   <xsl:template match="lvbba:InformatieObjectVersie" priority="1000" mode="M6">
      <xsl:variable name="Expression-ID"
                    select="data:ExpressionIdentificatie/data:FRBRExpression"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(data:InformatieObjectVersieMetadata/data:heeftBestanden/data:heeftBestand) = 1"/>
         <xsl:otherwise>
        {"code": "BHKV1014", "Expression-ID": "<xsl:text/>
            <xsl:value-of select="$Expression-ID"/>
            <xsl:text/>", "melding": "Element data:heeftBestanden van <xsl:text/>
            <xsl:value-of select="$Expression-ID"/>
            <xsl:text/> heeft géén of meer dan één bestand. Dit is niet toegestaan, lever slechts één bestand aan.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_023heeftGeboorteregeling met juiste soortWork en formaatInformatieobject-->
   <!--RULE -->
   <xsl:template match="lvbba:AanleveringInformatieObject//lvbba:InformatieObjectVersie[normalize-space(//data:soortWork) = '/join/id/stop/work_010'][normalize-space(//data:formaatInformatieobject) = '/join/id/stop/gio_002']"
                 priority="1000"
                 mode="M7">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="//data:heeftGeboorteregeling"/>
         <xsl:otherwise>{"code": "BHKV1015", "id": "<xsl:text/>
            <xsl:value-of select="//data:FRBRExpression"/>
            <xsl:text/>", "melding": "heeftGeboorteregeling voor <xsl:text/>
            <xsl:value-of select="//data:FRBRExpression"/>
            <xsl:text/> is niet aanwezig, is verplicht wanneer soortWork=/join/id/stop/work_010 èn formaatinformatieobject=/join/id/stop/informatieobject/gio_002. Voeg de AKN-identificatie voor heeftGeboorteregeling toe.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_024Informatieobject van het juiste type-->
   <!--RULE -->
   <xsl:template match="lvbba:AanleveringInformatieObject//lvbba:InformatieObjectVersie//data:ExpressionIdentificatie"
                 priority="1000"
                 mode="M8">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="normalize-space(data:soortWork) = '/join/id/stop/work_010'"/>
         <xsl:otherwise>{"code": "BHKV1016", "work": "<xsl:text/>
            <xsl:value-of select="data:soortWork"/>
            <xsl:text/>", "id": "<xsl:text/>
            <xsl:value-of select="data:FRBRExpression"/>
            <xsl:text/>", "melding": "Het aangeleverde informatieobject <xsl:text/>
            <xsl:value-of select="data:FRBRExpression"/>
            <xsl:text/> heeft als soortWork <xsl:text/>
            <xsl:value-of select="data:soortWork"/>
            <xsl:text/> dit moet '/join/id/stop/work_010' zijn.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_025Officieletitel gelijk aan FRBRWork-->
   <!--RULE -->
   <xsl:template match="lvbba:InformatieObjectVersie/data:InformatieObjectMetadata/data:officieleTitel"
                 priority="1000"
                 mode="M9">
      <xsl:variable name="titel" select="normalize-space(.)"/>
      <xsl:variable name="work"
                    select="normalize-space(ancestor::lvbba:InformatieObjectVersie/data:ExpressionIdentificatie/data:FRBRWork)"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$work = $titel"/>
         <xsl:otherwise>
      {"code": "BHKV1017", "work": "<xsl:text/>
            <xsl:value-of select="$work"/>
            <xsl:text/>", "titel": "<xsl:text/>
            <xsl:value-of select="$titel"/>
            <xsl:text/>", "melding": "De officiele titel <xsl:text/>
            <xsl:value-of select="$titel"/>
            <xsl:text/> komt niet overeen met de identifier FRBRWork <xsl:text/>
            <xsl:value-of select="$work"/>
            <xsl:text/>", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <!--PATTERN sch_lvbba_026De collectie gebruikt in de AKN identifier van een informatieobject MOET overeenkomen met zijn data:publicatieinstructie-->
   <!--RULE -->
   <xsl:template match="lvbba:InformatieObjectVersie/data:InformatieObjectMetadata/data:publicatieinstructie"
                 priority="1000"
                 mode="M10">
      <xsl:variable name="work"
                    select="normalize-space(ancestor::lvbba:InformatieObjectVersie/data:ExpressionIdentificatie/data:FRBRWork)"/>
      <xsl:variable name="Work_reeks" select="tokenize($work, '/')"/>
      <xsl:variable name="Work_collectie" select="$Work_reeks[4]"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="(((./string()='TeConsolideren') and ($Work_collectie='regdata')) or                                                  ((./string()='AlleenBekendTeMaken') and ($Work_collectie='pubdata')) or                 ((./string()='Informatief') and ($Work_collectie='infodata')))"/>
         <xsl:otherwise>
      {"code": "BHKV1018", "Work-ID": "<xsl:text/>
            <xsl:value-of select="$work"/>
            <xsl:text/>", "substring": "<xsl:text/>
            <xsl:value-of select="./string()"/>
            <xsl:text/>", "melding": "De collectie in de FRBRWork identifier <xsl:text/>
            <xsl:value-of select="$work"/>
            <xsl:text/> komt niet overeen met de publicatieinstructie <xsl:text/>
            <xsl:value-of select="./string()"/>
            <xsl:text/>", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
</xsl:stylesheet>
