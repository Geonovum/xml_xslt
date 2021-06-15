<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
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
      <xsl:apply-templates select="/" mode="M4"/>
      <xsl:apply-templates select="/" mode="M5"/>
      <xsl:apply-templates select="/" mode="M6"/>
      <xsl:apply-templates select="/" mode="M7"/>
      <xsl:apply-templates select="/" mode="M8"/>
      <xsl:apply-templates select="/" mode="M9"/>
      <xsl:apply-templates select="/" mode="M10"/>
      <xsl:apply-templates select="/" mode="M11"/>
      <xsl:apply-templates select="/" mode="M12"/>
      <xsl:apply-templates select="/" mode="M13"/>
      <xsl:apply-templates select="/" mode="M14"/>
      <xsl:apply-templates select="/" mode="M15"/>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <!--PATTERN sch_tekst_024Regelingen - initieel met componentnaam-->
   <!--RULE -->
   <xsl:template match="tekst:BesluitKlassiek/tekst:RegelingKlassiek | tekst:WijzigBijlage/tekst:RegelingCompact | tekst:WijzigBijlage/tekst:RegelingVrijetekst | tekst:WijzigBijlage/tekst:RegelingTijdelijkdeel"
                 priority="1000"
                 mode="M4">
      <xsl:variable name="regeling">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="child::tekst:RegelingOpschrift">
               <xsl:value-of select="string-join(child::tekst:RegelingOpschrift/*/normalize-space(), '')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="string-join(tekst:*/tekst:RegelingOpschrift/*/normalize-space(), '')"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="@componentnaam"/>
         <xsl:otherwise> {"code": "STOP0024", "regeling": "<xsl:text/>
            <xsl:value-of select="$regeling"/>
            <xsl:text/>", "melding": "De initiële regeling \"<xsl:text/>
            <xsl:value-of select="$regeling"/>
            <xsl:text/>\" heeft geen attribuut @componentnaam, dit attribuut is voor een initiële regeling verplicht. Voeg het attribuut toe met een unieke naamgeving.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="@wordt"/>
         <xsl:otherwise> {"code": "STOP0025", "regeling": "<xsl:text/>
            <xsl:value-of select="$regeling"/>
            <xsl:text/>", "melding": "De initiële regeling \"<xsl:text/>
            <xsl:value-of select="$regeling"/>
            <xsl:text/>\" heeft geen attribuut @wordt, dit attribuut is voor een initiële regeling verplicht. Voeg het attribuut toe met als waarde de juiste AKN versie-identifier", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M4"/>
   <xsl:template match="@*|node()" priority="-2" mode="M4">
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>
   <!--PATTERN sch_tekst_031Identificatie - componentnaam uniek-->
   <!--RULE -->
   <xsl:template match="tekst:*[@componentnaam]" priority="1000" mode="M5">
      <xsl:variable name="mijnComponent" select="@componentnaam"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(//tekst:*[@componentnaam = $mijnComponent]) = 1"/>
         <xsl:otherwise> {"code": "STOP0026", "component": "<xsl:text/>
            <xsl:value-of select="$mijnComponent"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>", "melding": "De componentnaam \"<xsl:text/>
            <xsl:value-of select="$mijnComponent"/>
            <xsl:text/> binnen <xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/> is niet uniek. Pas de componentnaam aan om deze uniek te maken", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <!--PATTERN sch_tekst_012Identificatie - eId, wId binnen een AKN-component-->
   <!--RULE -->
   <xsl:template match="tekst:*[@componentnaam]" priority="1000" mode="M6">
      <xsl:variable name="component" select="@componentnaam"/>
      <xsl:variable name="index">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="//tekst:*[@eId][ancestor::tekst:*[@componentnaam][1][@componentnaam = $component]][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijderContainer'])]">
            <xsl:sort select="@eId"/>
            <e>
               <xsl:value-of select="@eId"/>
            </e>
         </xsl:for-each>
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="//tekst:*[@eId][ancestor::tekst:*[@componentnaam][1][@componentnaam = $component]][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijderContainer'])]">
            <xsl:sort select="@wId"/>
            <w>
               <xsl:value-of select="@wId"/>
            </w>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="eId-fout">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="$index/e[preceding-sibling::e = .]">
            <xsl:value-of select="."/>
            <xsl:if test="not(position() = last())">
               <xsl:text>; </xsl:text>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="wId-fout">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="$index/w[preceding-sibling::w = .]">
            <xsl:value-of select="self::w/."/>
            <xsl:if test="not(position() = last())">
               <xsl:text>; </xsl:text>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$eId-fout = ''"/>
         <xsl:otherwise> {"code": "STOP0027", "eId": "<xsl:text/>
            <xsl:value-of select="$eId-fout"/>
            <xsl:text/>", "component": "<xsl:text/>
            <xsl:value-of select="$component"/>
            <xsl:text/>", "melding": "De eId '<xsl:text/>
            <xsl:value-of select="$eId-fout"/>
            <xsl:text/>' binnen component <xsl:text/>
            <xsl:value-of select="$component"/>
            <xsl:text/> moet uniek zijn. Controleer de opbouw van de eId en corrigeer deze", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$wId-fout = ''"/>
         <xsl:otherwise> {"code": "STOP0028", "wId": "<xsl:text/>
            <xsl:value-of select="$wId-fout"/>
            <xsl:text/>", "component": "<xsl:text/>
            <xsl:value-of select="$component"/>
            <xsl:text/>", "melding": "De wId '<xsl:text/>
            <xsl:value-of select="$wId-fout"/>
            <xsl:text/>' binnen component <xsl:text/>
            <xsl:value-of select="$component"/>
            <xsl:text/> moet uniek zijn. Controleer de opbouw van de wId en corrigeer deze", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <!--PATTERN sch_tekst_018RegelingMutatie - WijzigInstructies in een WijzigArtikel-->
   <!--RULE -->
   <xsl:template match="tekst:WijzigArtikel//tekst:WijzigInstructies"
                 priority="1000"
                 mode="M7">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="ancestor::tekst:BesluitKlassiek"/>
         <xsl:otherwise> {"code": "STOP0039", "naam": "<xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>", "melding": "Het element WijzigInstructies binnen element <xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>
            <xsl:text/> met eId \"<xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>\" is niet toegestaan. Verwijder de WijzigInstructies, of verplaats deze naar een RegelingMutatie binnen een WijzigBijlage.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <!--PATTERN sch_tekst_048RegelingMutatie - OpmerkingVersie in een WijzigArtikel-->
   <!--RULE -->
   <xsl:template match="tekst:WijzigArtikel//tekst:OpmerkingVersie"
                 priority="1000"
                 mode="M8">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="ancestor::tekst:BesluitKlassiek"/>
         <xsl:otherwise> {"code": "STOP0051", "naam": "<xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>", "melding": "Het element OpmerkingVersie binnen element <xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>
            <xsl:text/> met eId \"<xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>\" is alleen toegestaan in een BesluitCompact. Verwijder de OpmerkingVersie.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <!--PATTERN sch_tekst_019RegelingMutatie - in een WijzigArtikel-->
   <!--RULE -->
   <xsl:template match="tekst:WijzigArtikel//tekst:RegelingMutatie"
                 priority="1000"
                 mode="M9">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="ancestor::tekst:Lichaam/parent::tekst:BesluitKlassiek | ancestor::tekst:Lichaam/parent::tekst:RegelingKlassiek"/>
         <xsl:otherwise> {"code": "STOP0040", "naam": "<xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>", "melding": "Het element RegelingMutatie binnen element <xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>
            <xsl:text/> met eId \"<xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>\" is niet toegestaan. Neem de RegelingMutatie op in een WijzigBijlage.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <!--PATTERN sch_tekst_020renvooi in Wat-->
   <!--RULE -->
   <xsl:template match="tekst:Wat" priority="1000" mode="M10">

		<!--REPORT fout-->
      <xsl:if test="tekst:VerwijderdeTekst | tekst:NieuweTekst"> {"code": "STOP0047", "naam": "<xsl:text/>
         <xsl:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>
         <xsl:text/>", "eId": "<xsl:text/>
         <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
         <xsl:text/>", "melding": "Het element Wat van de RegelingMutatie binnen element <xsl:text/>
         <xsl:value-of select="local-name(ancestor::tekst:*[@eId][1])"/>
         <xsl:text/> met eId \"<xsl:text/>
         <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
         <xsl:text/>\" bevat renvooimarkeringen. Verwijder de element(en) NieuweTekst en VerwijderdeTekst.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <!--PATTERN sch_tekst_021wijzigactie nieuweContainer verwijderContainer op andere inhouds-element dan
      Groep-->
   <!--RULE -->
   <xsl:template match="tekst:Inhoud//tekst:*[@wijzigactie][local-name() != 'Groep']"
                 priority="1000"
                 mode="M11">

		<!--REPORT fout-->
      <xsl:if test="(@wijzigactie = 'nieuweContainer' or @wijzigactie = 'verwijderContainer')">
        {"code": "STOP0048", "naam": "<xsl:text/>
         <xsl:value-of select="local-name(.)"/>
         <xsl:text/>", "eId": "<xsl:text/>
         <xsl:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId"/>
         <xsl:text/>", "melding": "Op element <xsl:text/>
         <xsl:value-of select="local-name(.)"/>
         <xsl:text/> met (bovenliggend) eId <xsl:text/>
         <xsl:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId"/>
         <xsl:text/> is de wijzigactie \"nieuweContainer\" en \"verwijderContainer\" toegepast. Dit kan leiden tot invalide XML of informatieverlies. Verwijder de @wijzigactie.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <!--PATTERN sch_tekst_0045@Wijzigactie voor Inhoud-->
   <!--RULE -->
   <xsl:template match="tekst:Vervang//tekst:Inhoud[@wijzigactie]"
                 priority="1000"
                 mode="M12">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="parent::tekst:*/tekst:Gereserveerd | parent::tekst:*/tekst:Vervallen  | parent::tekst:*/tekst:Lid"/>
         <xsl:otherwise>{"code": "STOP0063", "naam": "<xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:Vervang[@wat][1])"/>
            <xsl:text/>", "wat": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:Vervang[@wat][1]/@wat"/>
            <xsl:text/>", "melding": "Het element Inhoud van <xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:Vervang[@wat][1])"/>
            <xsl:text/> met het attribuut @wat \"<xsl:text/>
            <xsl:value-of select="ancestor::tekst:Vervang[@wat][1]/@wat"/>
            <xsl:text/>\" heeft ten onrechte een attribuut @wijzigactie. Dit is alleen toegestaan indien gecombineerd met een Gereserveerd, Vervallen of Lid. Verwijder het attribuut @wijzigactie.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <!--PATTERN sch_tekst_046Een wijzigactie voor Sluiting-->
   <!--RULE -->
   <xsl:template match="tekst:Sluiting[@wijzigactie]" priority="1000" mode="M13">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="ancestor::tekst:Vervang[1]/ancestor::tekst:BesluitMutatie"/>
         <xsl:otherwise>
      {"code": "STOP0065", "naam": "<xsl:text/>
            <xsl:value-of select="local-name()"/>
            <xsl:text/>", "melding": "Het attribuut @wijzigactie is niet toegestaan voor element <xsl:text/>
            <xsl:value-of select="local-name()"/>
            <xsl:text/> buiten een BesluitMutatie/Vervang. Verwijder het attribuut @wijzigactie", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <!--PATTERN sch_tekst_066-->
   <!--RULE -->
   <xsl:template match="*[@wordt][@was]" priority="1000" mode="M14">
      <xsl:variable name="wasWork" select="substring-before(@was/./string(), '@')"/>
      <xsl:variable name="wordtWork" select="substring-before(@wordt/./string(), '@')"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$wasWork = $wordtWork"/>
         <xsl:otherwise>
      {"code": "STOP0066", "wasID": "<xsl:text/>
            <xsl:value-of select="$wasWork"/>
            <xsl:text/>", "wordtID": "<xsl:text/>
            <xsl:value-of select="$wordtWork"/>
            <xsl:text/>", "melding": "De identificatie van de @was <xsl:text/>
            <xsl:value-of select="$wasWork"/>
            <xsl:text/> en @wordt <xsl:text/>
            <xsl:value-of select="$wordtWork"/>
            <xsl:text/> hebben niet dezelfde work-identificatie. Corrigeer de AKN-expression. identificatie.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <!--PATTERN sch_tekst_068Noot unieke ids-->
   <!--RULE -->
   <xsl:template match="tekst:*[@componentnaam]" priority="1000" mode="M15">
      <xsl:variable name="component" select="@componentnaam"/>
      <xsl:variable name="nootIndex">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="//tekst:Noot[ancestor::tekst:*[@componentnaam][1][@componentnaam = $component]][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijderContainer'])]">
            <xsl:sort select="@id"/>
            <n>
               <xsl:value-of select="@id"/>
            </n>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="nootId-fout">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="$nootIndex/n[preceding-sibling::n = .]">
            <xsl:value-of select="self::n/."/>
            <xsl:if test="not(position() = last())">
               <xsl:text>; </xsl:text>
            </xsl:if>
         </xsl:for-each>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$nootId-fout = ''"/>
         <xsl:otherwise> {"code": "STOP0067", "id": "<xsl:text/>
            <xsl:value-of select="$nootId-fout"/>
            <xsl:text/>", "component": "<xsl:text/>
            <xsl:value-of select="$component"/>
            <xsl:text/>", "melding": "De id voor tekst:Noot '<xsl:text/>
            <xsl:value-of select="$nootId-fout"/>
            <xsl:text/>' binnen component '<xsl:text/>
            <xsl:value-of select="$component"/>
            <xsl:text/>' moet uniek zijn. Controleer de id en corrigeer zodat de identificatie uniek is binnen de component.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
</xsl:stylesheet>
