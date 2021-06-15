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
   <xsl:key match="tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
            name="alleEIDs"
            use="@eId"/>
   <xsl:key match="tekst:*[@wId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
            name="alleWIDs"
            use="@wId"/>
   <xsl:key match="tekst:Noot[not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
            name="alleNootIDs"
            use="@id"/>
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
      <xsl:apply-templates select="/" mode="M16"/>
      <xsl:apply-templates select="/" mode="M17"/>
      <xsl:apply-templates select="/" mode="M20"/>
      <xsl:apply-templates select="/" mode="M21"/>
      <xsl:apply-templates select="/" mode="M22"/>
      <xsl:apply-templates select="/" mode="M23"/>
      <xsl:apply-templates select="/" mode="M24"/>
      <xsl:apply-templates select="/" mode="M25"/>
      <xsl:apply-templates select="/" mode="M26"/>
      <xsl:apply-templates select="/" mode="M27"/>
      <xsl:apply-templates select="/" mode="M28"/>
      <xsl:apply-templates select="/" mode="M29"/>
      <xsl:apply-templates select="/" mode="M30"/>
      <xsl:apply-templates select="/" mode="M31"/>
      <xsl:apply-templates select="/" mode="M32"/>
      <xsl:apply-templates select="/" mode="M33"/>
      <xsl:apply-templates select="/" mode="M34"/>
      <xsl:apply-templates select="/" mode="M35"/>
      <xsl:apply-templates select="/" mode="M37"/>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <!--PATTERN sch_tekst_001Lijst - Nummering lijstitems-->
   <!--RULE -->
   <xsl:template match="tekst:Lijst[@type = 'ongemarkeerd']"
                 priority="1001"
                 mode="M4">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(tekst:Li/tekst:LiNummer) = 0"/>
         <xsl:otherwise> {"code": "STOP0001", "eId": "<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/>", "melding": "De Lijst met eId <xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/> van type 'ongemarkeerd' heeft LiNummer-elementen met een nummering of symbolen, dit is niet toegestaan. Pas het type van de lijst aan of verwijder de LiNummer-elementen.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tekst:Lijst[@type = 'expliciet']" priority="1000" mode="M4">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(tekst:Li[tekst:LiNummer]) = count(tekst:Li)"/>
         <xsl:otherwise> {"code": "STOP0002", "eId": "<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/>", "melding": "De Lijst met eId <xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/> van type 'expliciet' heeft geen LiNummer elementen met nummering of symbolen, het gebruik van LiNummer is verplicht. Pas het type van de lijst aan of voeg LiNummer's met nummering of symbolen toe aan de lijst-items", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M4"/>
   <xsl:template match="@*|node()" priority="-2" mode="M4">
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>
   <!--PATTERN sch_tekst_022Alinea - Bevat content-->
   <!--RULE -->
   <xsl:template match="tekst:Al" priority="1000" mode="M5">

		<!--REPORT fout-->
      <xsl:if test="normalize-space(./string()) = '' and not(tekst:InlineTekstAfbeelding | tekst:Nootref)"> {"code": "STOP0005", "element": "<xsl:text/>
         <xsl:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/>
         <xsl:text/>", "eId": "<xsl:text/>
         <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
         <xsl:text/>", "melding": "De alinea voor element <xsl:text/>
         <xsl:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/>
         <xsl:text/> met id <xsl:text/>
         <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
         <xsl:text/> bevat geen tekst. Verwijder de lege alinea", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <!--PATTERN sch_tekst_027Kop - Bevat content-->
   <!--RULE -->
   <xsl:template match="tekst:Kop" priority="1000" mode="M6">

		<!--REPORT fout-->
      <xsl:if test="normalize-space(./string()) = ''"> {"code": "STOP0006", "element": "<xsl:text/>
         <xsl:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/>
         <xsl:text/>", "eId": "<xsl:text/>
         <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
         <xsl:text/>", "melding": "De kop voor element <xsl:text/>
         <xsl:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/>
         <xsl:text/> met id <xsl:text/>
         <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
         <xsl:text/> bevat geen tekst. Corrigeer de kop of verplaats de inhoud naar een ander element", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <!--PATTERN sch_tekst_003Tabel - Referenties naar een noot-->
   <!--RULE -->
   <xsl:template match="tekst:table//tekst:Nootref" priority="1001" mode="M7">
      <xsl:variable name="nootID" select="@refid"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="ancestor::tekst:table//tekst:Noot[@id = $nootID]"/>
         <xsl:otherwise> {"code": "STOP0008", "ref": "<xsl:text/>
            <xsl:value-of select="@refid"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:table/@eId"/>
            <xsl:text/>", "melding": "De referentie naar de noot met id <xsl:text/>
            <xsl:value-of select="@refid"/>
            <xsl:text/> verwijst niet naar een noot in dezelfde tabel <xsl:text/>
            <xsl:value-of select="ancestor::tekst:table/@eId"/>
            <xsl:text/>. Verplaats de noot waarnaar verwezen wordt naar de tabel of vervang de referentie in de tabel voor de noot waarnaar verwezen wordt", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tekst:Nootref" priority="1000" mode="M7">
      <xsl:variable name="nootID" select="@refid"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="ancestor::tekst:table"/>
         <xsl:otherwise> {"code": "STOP0007", "ref": "<xsl:text/>
            <xsl:value-of select="@refid"/>
            <xsl:text/>", "melding": "De referentie naar de noot met id <xsl:text/>
            <xsl:value-of select="@refid"/>
            <xsl:text/> staat niet in een tabel. Vervang de referentie naar de noot voor de noot waarnaar verwezen wordt", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <!--PATTERN sch_tekst_004Lijst - plaatsing tabel in een lijst-->
   <!--RULE -->
   <xsl:template match="tekst:Li[tekst:table]" priority="1000" mode="M8">

		<!--REPORT waarschuwing-->
      <xsl:if test="self::tekst:Li/tekst:table and not(ancestor::tekst:Instructie)"> {"code": "STOP0009", "eId": "<xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/>", "melding": "Het lijst-item <xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/> bevat een tabel, onderzoek of de tabel buiten de lijst kan worden geplaatst, eventueel door de lijst in delen op te splitsen", "ernst": "waarschuwing"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <!--PATTERN sch_tekst_032Illustratie - attributen kleur en schaal worden niet ondersteund-->
   <!--RULE -->
   <xsl:template match="tekst:Illustratie | tekst:InlineTekstAfbeelding"
                 priority="1000"
                 mode="M9">

		<!--REPORT waarschuwing-->
      <xsl:if test="@schaal"> {"code": "STOP0045", "ouder": "<xsl:text/>
         <xsl:value-of select="local-name(ancestor::*[@eId][1])"/>
         <xsl:text/>", "eId": "<xsl:text/>
         <xsl:value-of select="ancestor::*[@eId][1]/@eId"/>
         <xsl:text/>", "melding": "De Illustratie binnen <xsl:text/>
         <xsl:value-of select="local-name(ancestor::*[@eId][1])"/>
         <xsl:text/> met eId <xsl:text/>
         <xsl:value-of select="ancestor::*[@eId][1]/@eId"/>
         <xsl:text/> heeft een waarde voor attribuut @schaal. Dit attribuut wordt genegeerd in de publicatie van documenten volgens STOP @@@VERSIE@@@. In plaats daarvan wordt het attribuut @dpi gebruikt voor de berekening van de afbeeldingsgrootte. Verwijder het attribuut @schaal.", "ernst": "waarschuwing"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT waarschuwing-->
      <xsl:if test="@kleur"> {"code": "STOP0046", "ouder": "<xsl:text/>
         <xsl:value-of select="local-name(ancestor::*[@eId][1])"/>
         <xsl:text/>", "eId": "<xsl:text/>
         <xsl:value-of select="ancestor::*[@eId][1]/@eId"/>
         <xsl:text/>", "melding": "De Illustratie binnen <xsl:text/>
         <xsl:value-of select="local-name(ancestor::*[@eId][1])"/>
         <xsl:text/> met eId <xsl:text/>
         <xsl:value-of select="ancestor::*[@eId][1]/@eId"/>
         <xsl:text/> heeft een waarde voor attribuut @kleur. Dit attribuut wordt genegeerd in de publicatie van STOP @@@VERSIE@@@. Verwijder het attribuut @kleur.", "ernst": "waarschuwing"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <!--PATTERN sch_tekst_006Referentie intern - correcte verwijzing-->
   <!--RULE -->
   <xsl:template match="tekst:IntRef[not(ancestor::tekst:RegelingMutatie | ancestor::tekst:BesluitMutatie)]"
                 priority="1000"
                 mode="M10">
      <xsl:variable name="doelwit">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="starts-with(@ref, '!')">
               <xsl:value-of select="substring-after(@ref, '#')"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="@ref"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="component">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="starts-with(@ref, '!')">
               <xsl:value-of select="substring-before(translate(@ref, '!', ''), '#')"/>
            </xsl:when>
            <xsl:when test="ancestor::tekst:*[@componentnaam]">
               <xsl:value-of select="ancestor::tekst:*[@componentnaam]/@componentnaam"/>
            </xsl:when>
            <xsl:otherwise>[is_geen_component]</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="scopeNaam">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="@scope">
               <xsl:value-of select="@scope"/>
            </xsl:when>
            <xsl:otherwise>[geen-scope]</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="localName">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="//tekst:*[@eId = $doelwit and ($component = '[is_geen_component]' or ancestor::tekst:*[@componentnaam][1]/@componentnaam = $component) and not(ancestor::tekst:RegelingMutatie | ancestor::tekst:BesluitMutatie)]">
               <xsl:choose>
                  <xsl:when test="$component = '[is_geen_component]'">
                     <xsl:value-of select="//tekst:*[@eId = $doelwit][not(ancestor::tekst:*[@componentnaam])]/local-name()"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="//tekst:*[@eId = $doelwit][ancestor::tekst:*[@componentnaam][1]/@componentnaam = $component]/local-name()"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            <xsl:otherwise/>
         </xsl:choose>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="//tekst:*[@eId = $doelwit and ($component = '[is_geen_component]' or ancestor::tekst:*[@componentnaam][1]/@componentnaam = $component) and not(ancestor::tekst:RegelingMutatie | ancestor::tekst:BesluitMutatie)]"/>
         <xsl:otherwise> 
        {"code": "STOP0010", "ref": "<xsl:text/>
            <xsl:value-of select="$doelwit"/>
            <xsl:text/>", "melding": "De waarde van @ref van element tekst:IntRef met waarde <xsl:text/>
            <xsl:value-of select="$doelwit"/>
            <xsl:text/> komt niet voor als eId van een tekst-element in (de mutatie van) de tekst van dezelfde expression als de IntRef. Controleer de referentie, corrigeer of de referentie of de identificatie van het element waarnaar wordt verwezen.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$scopeNaam = '[geen-scope]' or $scopeNaam = $localName"/>
         <xsl:otherwise>
      {"code": "STOP0053", "ref": "<xsl:text/>
            <xsl:value-of select="$doelwit"/>
            <xsl:text/>", "scope": "<xsl:text/>
            <xsl:value-of select="$scopeNaam"/>
            <xsl:text/>", "local": "<xsl:text/>
            <xsl:value-of select="$localName"/>
            <xsl:text/>", "melding": "De scope <xsl:text/>
            <xsl:value-of select="$scopeNaam"/>
            <xsl:text/> van de IntRef met <xsl:text/>
            <xsl:value-of select="$doelwit"/>
            <xsl:text/> is niet gelijk aan de naam van het doelelement <xsl:text/>
            <xsl:value-of select="$localName"/>
            <xsl:text/>.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <!--PATTERN sch_tekst_028Referentie informatieobject - correcte verwijzing-->
   <!--RULE -->
   <xsl:template match="tekst:IntIoRef[not(ancestor::tekst:RegelingMutatie | ancestor::BesluitMutatie)]"
                 priority="1000"
                 mode="M11">
      <xsl:variable name="doelwit" select="@ref"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="//tekst:ExtIoRef[@wId = $doelwit]"/>
         <xsl:otherwise> {"code": "STOP0011", "element": "<xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>", "ref": "<xsl:text/>
            <xsl:value-of select="$doelwit"/>
            <xsl:text/>", "melding": "De @ref van element <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> met waarde <xsl:text/>
            <xsl:value-of select="$doelwit"/>
            <xsl:text/> verwijst niet naar een wId van een ExtIoRef binnen hetzelfde bestand. Controleer de referentie, corrigeer of de referentie of de wId identificatie van het element waarnaar wordt verwezen", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <!--PATTERN sch_tekst_007Referentie extern informatieobject-->
   <!--RULE -->
   <xsl:template match="tekst:ExtIoRef" priority="1000" mode="M12">
      <xsl:variable name="ref" select="normalize-space(@ref)"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $ref"/>
         <xsl:otherwise> {"code": "STOP0012", "eId": "<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/>", "melding": "De JOIN-identifier van ExtIoRef <xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/> in de tekst is niet gelijk aan de als referentie opgenomen JOIN-identificatie. Controleer de gebruikte JOIN-identicatie en plaats de juiste verwijzing als zowel de @ref als de tekst van het element ExtIoRef", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <!--PATTERN sch_tekst_008Identificatie - correct gebruik wId, eId -->
   <!--RULE -->
   <xsl:template match="//*[@eId]" priority="1000" mode="M13">
      <xsl:variable name="doelwitE" select="@eId"/>
      <xsl:variable name="doelwitW" select="@wId"/>
      <!--REPORT fout-->
      <xsl:if test="ends-with($doelwitE, '.')"> {"code": "STOP0013", "eId": "<xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/>", "element": "<xsl:text/>
         <xsl:value-of select="name(.)"/>
         <xsl:text/>", "melding": "Het attribuut @eId of een deel van de eId <xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/> van element <xsl:text/>
         <xsl:value-of select="name(.)"/>
         <xsl:text/> eindigt op een '.', dit is niet toegestaan. Verwijder de laatste punt(en) '.' voor deze eId", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="contains($doelwitE, '.__')"> {"code": "STOP0043", "eId": "<xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/>", "element": "<xsl:text/>
         <xsl:value-of select="name(.)"/>
         <xsl:text/>", "melding": "Het attribuut @eId of een deel van de eId <xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/> van element <xsl:text/>
         <xsl:value-of select="name(.)"/>
         <xsl:text/> eindigt op '.__', dit is niet toegestaan. Verwijder deze punt '.' binnen deze eId", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="ends-with($doelwitW, '.')"> {"code": "STOP0014", "wId": "<xsl:text/>
         <xsl:value-of select="@wId"/>
         <xsl:text/>", "element": "<xsl:text/>
         <xsl:value-of select="name(.)"/>
         <xsl:text/>", "melding": "Het attribuut @wId <xsl:text/>
         <xsl:value-of select="@wId"/>
         <xsl:text/> van element <xsl:text/>
         <xsl:value-of select="name(.)"/>
         <xsl:text/> eindigt op een '.', dit is niet toegestaan. Verwijder de laatste punt '.' van deze wId", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <!--REPORT fout-->
      <xsl:if test="contains($doelwitW, '.__')"> {"code": "STOP0044", "wId": "<xsl:text/>
         <xsl:value-of select="@wId"/>
         <xsl:text/>", "element": "<xsl:text/>
         <xsl:value-of select="name(.)"/>
         <xsl:text/>", "melding": "Het attribuut @wId <xsl:text/>
         <xsl:value-of select="@wId"/>
         <xsl:text/> van element <xsl:text/>
         <xsl:value-of select="name(.)"/>
         <xsl:text/> eindigt op een '.__', dit is niet toegestaan. Verwijder deze punt '.' binnen deze wId", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <!--PATTERN sch_tekst_023RegelingTijdelijkdeel - WijzigArtikel niet toegestaan-->
   <!--RULE -->
   <xsl:template match="tekst:RegelingTijdelijkdeel//tekst:WijzigArtikel"
                 priority="1000"
                 mode="M14">

		<!--REPORT fout-->
      <xsl:if test="self::tekst:WijzigArtikel"> {"code": "STOP0015", "eId": "<xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/>", "melding": "Het WijzigArtikel <xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/> is in een RegelingTijdelijkdeel niet toegestaan. Verwijder het WijzigArtikel of pas dit aan naar een Artikel indien dit mogelijk is", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <!--PATTERN sch_tekst_026RegelingCompact - WijzigArtikel niet toegestaan-->
   <!--RULE -->
   <xsl:template match="tekst:RegelingCompact//tekst:WijzigArtikel"
                 priority="1000"
                 mode="M15">

		<!--REPORT fout-->
      <xsl:if test="self::tekst:WijzigArtikel"> {"code": "STOP0016", "eId": "<xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/>", "melding": "Het WijzigArtikel <xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/> is in een RegelingCompact niet toegestaan. Verwijder het WijzigArtikel of pas dit aan naar een Artikel indien dit mogelijk is", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <!--PATTERN sch_tekst_009Mutaties - Wijzigingen tekstueel-->
   <!--RULE -->
   <xsl:template match="tekst:NieuweTekst | tekst:VerwijderdeTekst"
                 priority="1000"
                 mode="M16">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="ancestor::tekst:RegelingMutatie or ancestor::tekst:BesluitMutatie"/>
         <xsl:otherwise> {"code": "STOP0017", "ouder": "<xsl:text/>
            <xsl:value-of select="local-name(parent::tekst:*)"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>", "element": "<xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>", "melding": "Tekstuele wijziging is niet toegestaan buiten de context van een tekst:RegelingMutatie of tekst:BesluitMutatie. element <xsl:text/>
            <xsl:value-of select="local-name(parent::tekst:*)"/>
            <xsl:text/> met id \"<xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>\" bevat een <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>. Verwijder het element <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <!--PATTERN sch_tekst_010Mutaties - Wijzigingen structuur-->
   <!--RULE -->
   <xsl:template match="tekst:*[@wijzigactie]" priority="1000" mode="M17">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="ancestor::tekst:RegelingMutatie or ancestor::tekst:BesluitMutatie"/>
         <xsl:otherwise> {"code": "STOP0018", "element": "<xsl:text/>
            <xsl:value-of select="local-name()"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>", "melding": "Een attribuut @wijzigactie is niet toegestaan op element <xsl:text/>
            <xsl:value-of select="local-name()"/>
            <xsl:text/> met id \"<xsl:text/>
            <xsl:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>\" buiten de context van een tekst:RegelingMutatie of tekst:BesluitMutatie. Verwijder het attribuut @wijzigactie", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <!--PATTERN sch_tekst_011Identificatie - Alle wId en eId buiten een AKN-component zijn uniek-->
   <!--RULE -->
   <xsl:template match="tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
                 priority="1000"
                 mode="M20">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(key('alleEIDs', @eId)) = 1"/>
         <xsl:otherwise> {"code": "STOP0020", "eId": "<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/>", "melding": "De eId '<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/>' binnen het bereik is niet uniek. Controleer de opbouw van de eId en corrigeer deze", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(key('alleWIDs', @wId)) = 1"/>
         <xsl:otherwise> {"code": "STOP0021", "wId": "<xsl:text/>
            <xsl:value-of select="@wId"/>
            <xsl:text/>", "melding": "De wId '<xsl:text/>
            <xsl:value-of select="@wId"/>
            <xsl:text/>' binnen het bereik is niet uniek. Controleer de opbouw van de wId en corrigeer deze", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <!--PATTERN sch_tekst_020Identificatie - AKN-naamgeving voor eId en wId-->
   <!--RULE -->
   <xsl:template match="*[@eId]" priority="1000" mode="M21">
      <xsl:variable name="AKNnaam">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="matches(local-name(), 'Lichaam')">body</xsl:when>
            <xsl:when test="matches(local-name(), 'RegelingOpschrift')">longTitle</xsl:when>
            <xsl:when test="matches(local-name(), 'AlgemeneToelichting')">genrecital</xsl:when>
            <xsl:when test="matches(local-name(), '^ArtikelgewijzeToelichting$')">artrecital</xsl:when>
            <xsl:when test="matches(local-name(), 'Artikel|WijzigArtikel')">art</xsl:when>
            <xsl:when test="matches(local-name(), 'WijzigLid|Lid')">para</xsl:when>
            <xsl:when test="matches(local-name(), 'Divisietekst')">content</xsl:when>
            <xsl:when test="matches(local-name(), 'Divisie')">div</xsl:when>
            <xsl:when test="matches(local-name(), 'Boek')">book</xsl:when>
            <xsl:when test="matches(local-name(), 'Titel')">title</xsl:when>
            <xsl:when test="matches(local-name(), 'Deel')">part</xsl:when>
            <xsl:when test="matches(local-name(), 'Hoofdstuk')">chp</xsl:when>
            <xsl:when test="matches(local-name(), 'Afdeling')">subchp</xsl:when>
            <xsl:when test="matches(local-name(), 'Paragraaf|Subparagraaf|Subsubparagraaf')">subsec</xsl:when>
            <xsl:when test="matches(local-name(), 'WijzigBijlage|Bijlage')">cmp</xsl:when>
            <xsl:when test="matches(local-name(), 'Inhoudsopgave')">toc</xsl:when>
            <xsl:when test="matches(local-name(), 'Motivering')">acc</xsl:when>
            <xsl:when test="matches(local-name(), 'Toelichting')">recital</xsl:when>
            <xsl:when test="matches(local-name(), 'InleidendeTekst')">intro</xsl:when>
            <xsl:when test="matches(local-name(), 'Aanhef')">formula_1</xsl:when>
            <xsl:when test="matches(local-name(), 'Kadertekst')">recital</xsl:when>
            <xsl:when test="matches(local-name(), 'Sluiting')">formula_2</xsl:when>
            <xsl:when test="matches(local-name(), 'table')">table</xsl:when>
            <xsl:when test="matches(local-name(), 'Figuur')">img</xsl:when>
            <xsl:when test="matches(local-name(), 'Formule')">math</xsl:when>
            <xsl:when test="matches(local-name(), 'Citaat')">cit</xsl:when>
            <xsl:when test="matches(local-name(), 'Begrippenlijst|Lijst')">list</xsl:when>
            <xsl:when test="matches(local-name(), 'Li|Begrip')">item</xsl:when>
            <xsl:when test="matches(local-name(), 'IntIoRef|ExtIoRef')">ref</xsl:when>
            <xsl:when test="matches(local-name(), 'Rectificatietekst')">content</xsl:when>
            <xsl:otherwise>X</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="mijnEID">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="contains(@eId, '__')">
               <xsl:value-of select="tokenize(@eId, '__')[last()]"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="@eId"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="mijnWID">
         <xsl:value-of xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="tokenize(@wId, '__')[last()]"/>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="starts-with($mijnEID, $AKNnaam)"/>
         <xsl:otherwise> {"code": "STOP0022", "AKNdeel": "<xsl:text/>
            <xsl:value-of select="$mijnEID"/>
            <xsl:text/>", "element": "<xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>", "waarde": "<xsl:text/>
            <xsl:value-of select="$AKNnaam"/>
            <xsl:text/>", "wId": "<xsl:text/>
            <xsl:value-of select="@wId"/>
            <xsl:text/>", "melding": "De AKN-naamgeving voor eId '<xsl:text/>
            <xsl:value-of select="$mijnEID"/>
            <xsl:text/>' is niet correct voor element <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> met id '<xsl:text/>
            <xsl:value-of select="@wId"/>
            <xsl:text/>', Dit moet zijn: '<xsl:text/>
            <xsl:value-of select="$AKNnaam"/>
            <xsl:text/>'. Pas de naamgeving voor dit element en alle onderliggende elementen aan. Controleer ook de naamgeving van de bijbehorende wId en onderliggende elementen.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="starts-with($mijnWID, $AKNnaam)"/>
         <xsl:otherwise> {"code": "STOP0023", "AKNdeel": "<xsl:text/>
            <xsl:value-of select="$mijnWID"/>
            <xsl:text/>", "element": "<xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>", "waarde": "<xsl:text/>
            <xsl:value-of select="$AKNnaam"/>
            <xsl:text/>", "wId": "<xsl:text/>
            <xsl:value-of select="@wId"/>
            <xsl:text/>", "melding": "De AKN-naamgeving voor wId '<xsl:text/>
            <xsl:value-of select="$mijnWID"/>
            <xsl:text/>' is niet correct voor element <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> met id '<xsl:text/>
            <xsl:value-of select="@wId"/>
            <xsl:text/>', Dit moet zijn: '<xsl:text/>
            <xsl:value-of select="$AKNnaam"/>
            <xsl:text/>'. Pas de naamgeving voor dit element en alle onderliggende elementen aan. Controleer ook de naamgeving van de bijbehorende eId en onderliggende elementen.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <!--PATTERN sch_tekst_014Tabel - minimale opbouw-->
   <!--RULE -->
   <xsl:template match="tekst:table" priority="1000" mode="M22">

		<!--ASSERT waarschuwing-->
      <xsl:choose>
         <xsl:when test="number(tekst:tgroup/@cols) &gt;= 2"/>
         <xsl:otherwise> {"code": "STOP0029", "eId": "<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/>", "melding": "De tabel met <xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/> heeft slechts 1 kolom, dit is niet toegestaan. Pas de tabel aan, of plaats de inhoud van de tabel naar bijvoorbeeld een element Kadertekst", "ernst": "waarschuwing"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--PATTERN sch_tekst_016Tabel - positie en identificatie van een tabelcel-->
   <!--RULE -->
   <xsl:template match="tekst:entry[@namest and @colname]"
                 priority="1000"
                 mode="M23">
      <xsl:variable name="start" select="@namest"/>
      <xsl:variable name="col" select="@colname"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$col = $start"/>
         <xsl:otherwise> {"code": "STOP0033", "naam": "<xsl:text/>
            <xsl:value-of select="@namest"/>
            <xsl:text/>", "nummer": "<xsl:text/>
            <xsl:value-of select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>
            <xsl:text/>", "ouder": "<xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:table/@eId"/>
            <xsl:text/>", "melding": "De start van de overspanning (@namest) van de cel <xsl:text/>
            <xsl:value-of select="@namest"/>
            <xsl:text/>, in de <xsl:text/>
            <xsl:value-of select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>
            <xsl:text/>e rij, van de <xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>
            <xsl:text/> van tabel <xsl:text/>
            <xsl:value-of select="ancestor::tekst:table/@eId"/>
            <xsl:text/> is niet gelijk aan de @colname van de cel.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="tekst:entry[@namest][@nameend]" priority="1000" mode="M24">
      <xsl:variable name="start" select="@namest"/>
      <xsl:variable name="end" select="@nameend"/>
      <xsl:variable name="colPosities">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="ancestor::tekst:tgroup/tekst:colspec">
            <xsl:variable name="colnum">
               <xsl:choose>
                  <xsl:when test="@colnum">
                     <xsl:value-of select="@colnum"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="position()"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <col colnum="{$colnum}" name="{@colname}"/>
         </xsl:for-each>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="xs:integer($colPosities/*[@name = $start]/@colnum) &lt;= xs:integer($colPosities/*[@name = $end]/@colnum)"/>
         <xsl:otherwise>
        {"code": "STOP0032", "naam": "<xsl:text/>
            <xsl:value-of select="@namest"/>
            <xsl:text/>", "nummer": "<xsl:text/>
            <xsl:value-of select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>
            <xsl:text/>", "ouder": "<xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:table/@eId"/>
            <xsl:text/>", "melding": "De entry met @namest \"<xsl:text/>
            <xsl:value-of select="@namest"/>
            <xsl:text/>\", van de <xsl:text/>
            <xsl:value-of select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>
            <xsl:text/>e rij, van de <xsl:text/>
            <xsl:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>
            <xsl:text/>, in de tabel met eId: <xsl:text/>
            <xsl:value-of select="ancestor::tekst:table/@eId"/>
            <xsl:text/>, heeft een positie bepaling groter dan de positie van de als @nameend genoemde cel. Corrigeer de gegevens voor de overspanning.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="tekst:entry[@colname]" priority="1000" mode="M25">
      <xsl:variable name="id" select="@colname"/>
      <!--REPORT fout-->
      <xsl:if test="not(ancestor::tekst:tgroup/tekst:colspec[@colname = $id])"> {"code": "STOP0036", "naam": "colname", "nummer": "<xsl:text/>
         <xsl:value-of select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>
         <xsl:text/>", "ouder": "<xsl:text/>
         <xsl:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>
         <xsl:text/>", "eId": "<xsl:text/>
         <xsl:value-of select="ancestor::tekst:table/@eId"/>
         <xsl:text/>", "melding": "De entry met @colname van de <xsl:text/>
         <xsl:value-of select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>
         <xsl:text/>e rij, van <xsl:text/>
         <xsl:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>
         <xsl:text/>, van de tabel met id: <xsl:text/>
         <xsl:value-of select="ancestor::tekst:table/@eId"/>
         <xsl:text/> , verwijst niet naar een bestaande kolom. Controleer en corrigeer de identifier voor de kolom (@colname)", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <!--PATTERN sch_tekst_017Tabel - het aantal cellen is correct-->
   <!--RULE -->
   <xsl:template match="tekst:tgroup/tekst:thead | tekst:tgroup/tekst:tbody"
                 priority="1000"
                 mode="M26">
      <xsl:variable name="totaalCellen"
                    select="count(tekst:row) * number(parent::tekst:tgroup/@cols)"/>
      <xsl:variable name="colPosities">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="parent::tekst:tgroup/tekst:colspec">
            <xsl:variable name="colnum">
               <xsl:choose>
                  <xsl:when test="@colnum">
                     <xsl:value-of select="@colnum"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="position()"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <col colnum="{$colnum}" name="{@colname}"/>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="cellen"
                    select="count(//tekst:entry[not(@wijzigactie = 'verwijder')])"/>
      <xsl:variable name="spanEinde">
         <xsl:for-each xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
                       select="self::tekst:tbody//tekst:entry[not(@wijzigactie = 'verwijder')] | self::tekst:thead//tekst:entry[not(@wijzigactie = 'verwijder')]">
            <xsl:variable as="xs:string?" name="namest" select="@namest"/>
            <xsl:variable as="xs:string?" name="nameend" select="@nameend"/>
            <xsl:variable as="xs:integer?"
                          name="numend"
                          select="$colPosities/*[@name = $nameend]/@colnum"/>
            <xsl:variable as="xs:integer?"
                          name="numst"
                          select="$colPosities/*[@name = $namest]/@colnum"/>
            <nr>
               <xsl:choose>
                  <xsl:when test="$numend and $numst and @morerows">
                     <xsl:value-of select="($numend - $numst + 1) * (@morerows + 1)"/>
                  </xsl:when>
                  <xsl:when test="$numend and $numst">
                     <xsl:value-of select="$numend - $numst + 1"/>
                  </xsl:when>
                  <xsl:when test="@morerows">
                     <xsl:value-of select="1 + @morerows"/>
                  </xsl:when>
                  <xsl:otherwise>1</xsl:otherwise>
               </xsl:choose>
            </nr>
         </xsl:for-each>
      </xsl:variable>
      <xsl:variable name="spannend" select="sum($spanEinde/*)"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="number(parent::tekst:tgroup/@cols) = count(parent::tekst:tgroup/tekst:colspec)"/>
         <xsl:otherwise> {"code": "STOP0037", "nummer": "<xsl:text/>
            <xsl:value-of select="count(parent::tekst:tgroup/tekst:colspec)"/>
            <xsl:text/>", "naam": "<xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:table/@eId"/>
            <xsl:text/>", "aantal": "<xsl:text/>
            <xsl:value-of select="parent::tekst:tgroup/@cols"/>
            <xsl:text/>", "melding": "Het aantal colspec's (<xsl:text/>
            <xsl:value-of select="count(parent::tekst:tgroup/tekst:colspec)"/>
            <xsl:text/>) voor <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> in tabel <xsl:text/>
            <xsl:value-of select="ancestor::tekst:table/@eId"/>
            <xsl:text/> komt niet overeen met het aantal kolommen (<xsl:text/>
            <xsl:value-of select="parent::tekst:tgroup/@cols"/>
            <xsl:text/>).", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="$totaalCellen = $spannend"/>
         <xsl:otherwise> {"code": "STOP0038", "aantal": "<xsl:text/>
            <xsl:value-of select="$spannend"/>
            <xsl:text/>", "naam": "<xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:table/@eId"/>
            <xsl:text/>", "nummer": "<xsl:text/>
            <xsl:value-of select="$totaalCellen"/>
            <xsl:text/>", "melding": "Het aantal cellen in <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> van tabel \"<xsl:text/>
            <xsl:value-of select="ancestor::tekst:table/@eId"/>
            <xsl:text/>\" komt niet overeen met de verwachting (resultaat: <xsl:text/>
            <xsl:value-of select="$spannend"/>
            <xsl:text/> van verwachting <xsl:text/>
            <xsl:value-of select="$totaalCellen"/>
            <xsl:text/>).", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <!--PATTERN sch_tekst_033Externe referentie, notatie-->
   <!--RULE -->
   <xsl:template match="tekst:ExtRef" priority="1000" mode="M27">
      <xsl:variable name="notatie">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="@soort = 'AKN'">/akn/</xsl:when>
            <xsl:when test="@soort = 'JCI'">jci1</xsl:when>
            <xsl:when test="@soort = 'URL'">http</xsl:when>
            <xsl:when test="@soort = 'JOIN'">/join/</xsl:when>
            <xsl:when test="@soort = 'document'"/>
         </xsl:choose>
      </xsl:variable>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="starts-with(@ref, $notatie)"/>
         <xsl:otherwise>{"code": "STOP0050", "type": "<xsl:text/>
            <xsl:value-of select="@soort"/>
            <xsl:text/>", "ref": "<xsl:text/>
            <xsl:value-of select="@ref"/>
            <xsl:text/>", "melding": "De ExtRef van het type <xsl:text/>
            <xsl:value-of select="@soort"/>
            <xsl:text/> met referentie <xsl:text/>
            <xsl:value-of select="@ref"/>
            <xsl:text/> heeft niet de juiste notatie.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--PATTERN sch_tekst_037Gereserveerd zonder opvolgende elementen-->
   <!--RULE -->
   <xsl:template match="tekst:Gereserveerd[not(ancestor::tekst:Vervang)][not(ancestor::tekst:Artikel)]"
                 priority="1000"
                 mode="M28">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="not(following-sibling::tekst:*)"/>
         <xsl:otherwise> {"code": "STOP0055", "naam": "<xsl:text/>
            <xsl:value-of select="local-name(following-sibling::tekst:*[1])"/>
            <xsl:text/>", "element": "<xsl:text/>
            <xsl:value-of select="local-name(parent::tekst:*)"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="parent::tekst:*/@eId"/>
            <xsl:text/>", "melding": "Het element <xsl:text/>
            <xsl:value-of select="local-name(following-sibling::tekst:*[1])"/>
            <xsl:text/> binnen <xsl:text/>
            <xsl:value-of select="local-name(parent::tekst:*)"/>
            <xsl:text/> met eId: \"<xsl:text/>
            <xsl:value-of select="parent::tekst:*/@eId"/>
            <xsl:text/>\" is niet toegestaan na een element Gereserveerd. Verwijder het element Gereserveerd of verplaats dit element naar een eigen structuur of tekst.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <!--PATTERN sch_tekst_070Vervallen zonder opvolgende elementen-->
   <!--RULE -->
   <xsl:template match="tekst:Artikel[not(ancestor::tekst:Vervang)]"
                 priority="1000"
                 mode="M29">

		<!--REPORT fout-->
      <xsl:if test="(child::tekst:Lid and (child::tekst:Inhoud or child::tekst:Vervallen or child::tekst:Gereserveerd)) or (child::tekst:Inhoud and (child::tekst:Vervallen or child::tekst:Gereserveerd))"> {"code": "STOP0070", "naam": "<xsl:text/>
         <xsl:value-of select="local-name()"/>
         <xsl:text/>", "eId": "<xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/>", "melding": "Het <xsl:text/>
         <xsl:value-of select="local-name()"/>
         <xsl:text/> met eId '<xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/>' heeft een combinatie van elementen dat niet is toegestaan. Corrigeer het artikel door de combinatie van elementen te verwijderen.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <!--PATTERN sch_tekst_039Structuur compleet-->
   <!--RULE -->
   <xsl:template match="tekst:Afdeling | tekst:Bijlage | tekst:Boek | tekst:Deel | tekst:Divisie | tekst:Hoofdstuk | tekst:Paragraaf | tekst:Subparagraaf | tekst:Subsubparagraaf | tekst:Titel[not(parent::tekst:Figuur)]"
                 priority="1000"
                 mode="M30">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="child::tekst:*[not(self::tekst:Kop)]"/>
         <xsl:otherwise> {"code": "STOP0058", "naam": "<xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/>", "melding": "Het element <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> met eId: \"<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/> is niet compleet, een kind-element anders dan een Kop is verplicht. Completeer of verwijder dit structuur-element.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <!--PATTERN sch_tekst_040Artikel compleet-->
   <!--RULE -->
   <xsl:template match="tekst:Artikel" priority="1000" mode="M31">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="child::tekst:*[not(self::tekst:Kop)]"/>
         <xsl:otherwise> {"code": "STOP0059", "naam": "<xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/>", "melding": "Het element <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> met eId: \"<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/> is niet compleet, een kind-element anders dan een Kop is verplicht. Completeer of verwijder dit element.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <!--PATTERN sch_tekst_041Divisietekst compleet-->
   <!--RULE -->
   <xsl:template match="tekst:Divisietekst" priority="1000" mode="M32">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="child::tekst:*[not(self::tekst:Kop)]"/>
         <xsl:otherwise> {"code": "STOP0060", "naam": "<xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/>", "melding": "Het element <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/> met eId: \"<xsl:text/>
            <xsl:value-of select="@eId"/>
            <xsl:text/> is niet compleet, een kind-element anders dan een Kop is verplicht. Completeer of verwijder dit element.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <!--PATTERN sch_tekst_043Kennisgeving zonder divisie-->
   <!--RULE -->
   <xsl:template match="tekst:Divisie[ancestor::tekst:Kennisgeving]"
                 priority="1000"
                 mode="M33">

		<!--REPORT fout-->
      <xsl:if test=".">{"code": "STOP0061", "eId": "<xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/>", "melding": "De kennisgeving bevat een Divisie met eId <xsl:text/>
         <xsl:value-of select="@eId"/>
         <xsl:text/>. Dit is niet toegestaan. Gebruik alleen Divisietekst.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <!--PATTERN sch_tekst_044Vervallen structuur-->
   <!--RULE -->
   <xsl:template match="tekst:Vervallen[not(ancestor::tekst:Vervang)][not(parent::tekst:Artikel)][not(parent::tekst:Divisietekst)]"
                 priority="1000"
                 mode="M34">

		<!--REPORT fout-->
      <xsl:if test="following-sibling::tekst:*[not(child::tekst:Vervallen)]">{"code": "STOP0062", "naam": "<xsl:text/>
         <xsl:value-of select="local-name(parent::tekst:*)"/>
         <xsl:text/>", "eId": "<xsl:text/>
         <xsl:value-of select="parent::tekst:*/@eId"/>
         <xsl:text/>", "element": "<xsl:text/>
         <xsl:value-of select="local-name(following-sibling::tekst:*[not(child::tekst:Vervallen)][1])"/>
         <xsl:text/>", "id": "<xsl:text/>
         <xsl:value-of select="following-sibling::tekst:*[not(child::tekst:Vervallen)][1]/@eId"/>
         <xsl:text/>", "melding": "Het element <xsl:text/>
         <xsl:value-of select="local-name(parent::tekst:*)"/>
         <xsl:text/> met eId: \"<xsl:text/>
         <xsl:value-of select="parent::tekst:*/@eId"/>
         <xsl:text/>\" is vervallen, maar heeft minstens nog een niet vervallen element\". Controleer vanaf element <xsl:text/>
         <xsl:value-of select="local-name(following-sibling::tekst:*[not(child::tekst:Vervallen)][1])"/>
         <xsl:text/> met eId \"<xsl:text/>
         <xsl:value-of select="following-sibling::tekst:*[not(child::tekst:Vervallen)][1]/@eId"/>
         <xsl:text/> of alle onderliggende elementen als vervallen zijn aangemerkt.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <!--PATTERN sch_tekst_045-->
   <!--RULE -->
   <xsl:template match="tekst:Contact" priority="1000" mode="M35">
      <xsl:variable name="pattern">
         <xsl:choose xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                     xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
            <xsl:when test="@soort = 'e-mail'">[^@]+@[^\.]+\..+</xsl:when>
            <xsl:otherwise>[onbekend-soort-adres]</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="adres" select="@adres/./string()"/>
      <!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="matches($adres, $pattern)"/>
         <xsl:otherwise>
        {"code": "STOP0064", "adres": "<xsl:text/>
            <xsl:value-of select="./string()"/>
            <xsl:text/>", "eId": "<xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/>", "melding": "Het e-mailadres <xsl:text/>
            <xsl:value-of select="./string()"/>
            <xsl:text/> zoals genoemd in het element Contact met eId <xsl:text/>
            <xsl:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>
            <xsl:text/> moet een correct geformatteerd e-mailadres zijn. Corrigeer het e-mailadres.", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <!--PATTERN sch_tekst_0046Noot/@id is uniek binnen component (kan niet in XSD vanwege component)-->
   <!--RULE -->
   <xsl:template match="tekst:Noot[not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
                 priority="1000"
                 mode="M37">

		<!--ASSERT fout-->
      <xsl:choose>
         <xsl:when test="count(key('alleNootIDs', @id)) &lt;= 1"/>
         <xsl:otherwise> {"code": "STOP0068", "id": "<xsl:text/>
            <xsl:value-of select="@id"/>
            <xsl:text/>", "melding": "De id '<xsl:text/>
            <xsl:value-of select="@id"/>
            <xsl:text/>' is niet uniek binnen zijn component. Controleer id en corrigeer deze", "ernst": "fout"},<xsl:value-of select="string('&#xA;')"/>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
</xsl:stylesheet>
