<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:lvbb="https://standaarden.overheid.nl/lvbb/stop/aanlevering/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:xlink="http://www.w3.org/1999/xlink">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <!-- namespaces OP -->
  <xsl:param name="data" select="string('https://standaarden.overheid.nl/stop/imop/data/')"/>
  <xsl:param name="dso" select="string('https://www.dso.nl/')"/>
  <xsl:param name="lvbb" select="string('https://standaarden.overheid.nl/lvbb/stop/aanlevering/')"/>
  <xsl:param name="tekst" select="string('https://standaarden.overheid.nl/stop/imop/tekst/')"/>
  <!-- namespaces OW -->
  <xsl:param name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
  <xsl:param name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
  <xsl:param name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
  <xsl:param name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
  <xsl:param name="manifest" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow')"/>
  <xsl:param name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
  <xsl:param name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
  <xsl:param name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
  <xsl:param name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
  <xsl:param name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
  <xsl:param name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
  <xsl:param name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
  <xsl:param name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
  <!-- algemeen -->
  <xsl:param name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
  <xsl:param name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>

  <!-- ExtIoRef -->
  <xsl:param name="unique_geometrie">
    <xsl:for-each select="//lvbb:AanleveringBesluit//tekst:Begrip[descendant::tekst:ExtIoRef]">
      <xsl:element name="gio">
        <xsl:element name="noemer">
          <xsl:value-of select="lower-case(./tekst:Term)"/>
        </xsl:element>
        <xsl:element name="join">
          <xsl:value-of select=".//tekst:ExtIoRef/@ref"/>
        </xsl:element>
        <xsl:element name="eId">
          <xsl:value-of select=".//tekst:ExtIoRef/@eId"/>
        </xsl:element>
        <xsl:element name="wId">
          <xsl:value-of select=".//tekst:ExtIoRef/@wId"/>
        </xsl:element>
      </xsl:element>
    </xsl:for-each>
  </xsl:param>

  <!-- algemeen -->

  <xsl:template match="/">
    <!-- LVBB -->
    <xsl:copy-of select="//lvbb:publicatieOpdracht"/>
    <!-- OW -->
    <xsl:call-template name="manifest"/>
    <xsl:for-each select=".//ow-dc:owBestand">
      <xsl:variable name="index" select="position()"/>
      <xsl:call-template name="owActiviteit">
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="objects" select=".//sl:stand[descendant::rol:Activiteit]"/>
      </xsl:call-template>
      <xsl:call-template name="owGebiedsaanwijzing">
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="objects" select=".//sl:stand[descendant::ga:Gebiedsaanwijzing]"/>
      </xsl:call-template>
      <xsl:call-template name="owHoofdlijn">
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="objects" select=".//sl:stand[descendant::vt:Hoofdlijn]"/>
      </xsl:call-template>
      <xsl:call-template name="owOmgevingsnorm">
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="objects" select=".//sl:stand[descendant::rol:Omgevingsnorm]"/>
      </xsl:call-template>
      <xsl:call-template name="owOmgevingswaarde">
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="objects" select=".//sl:stand[descendant::rol:Omgevingswaarde]"/>
      </xsl:call-template>
      <xsl:call-template name="owLocatie">
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="objects" select=".//sl:stand[descendant::l:Ambtsgebied,descendant::l:Gebied]"/>
      </xsl:call-template>
      <xsl:call-template name="owRegelingsgebied">
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="objects" select=".//sl:stand[descendant::rg:Regelingsgebied]"/>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select=".//(tekst:RegelingCompact,tekst:RegelingKlassiek,tekst:RegelingTijdelijkdeel,tekst:RegelingVrijetekst)">
      <xsl:variable name="index" select="position()"/>
      <xsl:call-template name="owRegeltekst">
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="objects" select=".//sl:stand[descendant::r:Regeltekst|descendant::r:RegelVoorIedereen]"/>
      </xsl:call-template>
      <xsl:call-template name="owDivisie">
        <xsl:with-param name="index" select="$index"/>
        <xsl:with-param name="objects" select=".//sl:stand[descendant::vt:Divisie|descendant::vt:Divisietekst|descendant::vt:Tekstdeel]"/>
      </xsl:call-template>
    </xsl:for-each>
    <!-- OP -->
    <xsl:call-template name="AanleveringBesluit"/>
  </xsl:template>

  <!-- OW -->

  <!-- manifest -->

  <xsl:template name="manifest">
    <xsl:result-document href="manifest-ow.xml" method="xml">
      <xsl:element name="Aanleveringen" namespace="{$manifest}">
        <xsl:namespace name="xsi" select="$xsi"/>
        <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/bestanden-ow/manifest-ow https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/generiek/manifest-ow.xsd')"/>
        <xsl:element name="domein" namespace="{$manifest}">
          <xsl:value-of select="string('omgevingswet')"/>
        </xsl:element>
        <xsl:for-each select="//data:ConsolidatieInformatie/data:BeoogdeRegelgeving/data:BeoogdeRegeling">
          <xsl:element name="Aanlevering" namespace="{$manifest}">
            <xsl:element name="WorkIDRegeling" namespace="{$manifest}">
              <xsl:value-of select="fn:tokenize(./data:instrumentVersie,'/nld')[1]"/>
            </xsl:element>
            <xsl:element name="DoelID" namespace="{$manifest}">
              <xsl:value-of select="(./data:doelen/data:doel)[1]"/>
            </xsl:element>
            <!-- owRegeltekst -->
            <xsl:variable name="objects" select="root()//sl:stand[descendant::r:Regeltekst|descendant::r:RegelVoorIedereen]"/>
            <xsl:if test="$objects">
              <xsl:element name="Bestand" namespace="{$manifest}">
                <xsl:element name="naam" namespace="{$manifest}">
                  <xsl:value-of select="string('owRegeltekst.xml')"/>
                </xsl:element>
                <xsl:for-each select="('Regeltekst','RegelVoorIedereen')">
                  <xsl:element name="objecttype" namespace="{$manifest}">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <!-- owDivisie -->
            <xsl:variable name="objects" select="root()//sl:stand[descendant::vt:Divisie|descendant::vt:Divisietekst|descendant::vt:Tekstdeel]"/>
            <xsl:if test="$objects">
              <xsl:element name="Bestand" namespace="{$manifest}">
                <xsl:element name="naam" namespace="{$manifest}">
                  <xsl:value-of select="string('owDivisie.xml')"/>
                </xsl:element>
                <xsl:for-each select="('Divisie','Divisietekst','Tekstdeel')">
                  <xsl:element name="objecttype" namespace="{$manifest}">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <!-- owActiviteit -->
            <xsl:variable name="objects" select="root()//sl:stand[descendant::rol:Activiteit]"/>
            <xsl:if test="$objects">
              <xsl:element name="Bestand" namespace="{$manifest}">
                <xsl:element name="naam" namespace="{$manifest}">
                  <xsl:value-of select="string('owActiviteit.xml')"/>
                </xsl:element>
                <xsl:for-each select="('Activiteit')">
                  <xsl:element name="objecttype" namespace="{$manifest}">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <!-- owGebiedsaanwijzing -->
            <xsl:variable name="objects" select="root()//sl:stand[descendant::ga:Gebiedsaanwijzing]"/>
            <xsl:if test="$objects">
              <xsl:element name="Bestand" namespace="{$manifest}">
                <xsl:element name="naam" namespace="{$manifest}">
                  <xsl:value-of select="string('owGebiedsaanwijzing.xml')"/>
                </xsl:element>
                <xsl:for-each select="('Gebiedsaanwijzing')">
                  <xsl:element name="objecttype" namespace="{$manifest}">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <!-- owHoofdlijn -->
            <xsl:variable name="objects" select="root()//sl:stand[descendant::vt:Hoofdlijn]"/>
            <xsl:if test="$objects">
              <xsl:element name="Bestand" namespace="{$manifest}">
                <xsl:element name="naam" namespace="{$manifest}">
                  <xsl:value-of select="string('owHoofdlijn.xml')"/>
                </xsl:element>
                <xsl:for-each select="('Hoofdlijn')">
                  <xsl:element name="objecttype" namespace="{$manifest}">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <!-- owOmgevingsnorm -->
            <xsl:variable name="objects" select="root()//sl:stand[descendant::rol:Omgevingsnorm]"/>
            <xsl:if test="$objects">
              <xsl:element name="Bestand" namespace="{$manifest}">
                <xsl:element name="naam" namespace="{$manifest}">
                  <xsl:value-of select="string('owOmgevingsnorm.xml')"/>
                </xsl:element>
                <xsl:for-each select="('Omgevingsnorm')">
                  <xsl:element name="objecttype" namespace="{$manifest}">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <!-- owOmgevingswaarde -->
            <xsl:variable name="objects" select="root()//sl:stand[descendant::rol:Omgevingswaarde]"/>
            <xsl:if test="$objects">
              <xsl:element name="Bestand" namespace="{$manifest}">
                <xsl:element name="naam" namespace="{$manifest}">
                  <xsl:value-of select="string('owOmgevingswaarde.xml')"/>
                </xsl:element>
                <xsl:for-each select="('Omgevingswaarde')">
                  <xsl:element name="objecttype" namespace="{$manifest}">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <!-- owLocatie -->
            <xsl:variable name="objects" select="root()//sl:stand[descendant::l:Ambtsgebied,descendant::l:Gebied]"/>
            <xsl:if test="$objects">
              <xsl:element name="Bestand" namespace="{$manifest}">
                <xsl:element name="naam" namespace="{$manifest}">
                  <xsl:value-of select="string('owLocatie.xml')"/>
                </xsl:element>
                <xsl:for-each select="('Ambtsgebied','Gebied')">
                  <xsl:element name="objecttype" namespace="{$manifest}">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
            <!-- owRegelingsgebied -->
            <xsl:variable name="objects" select="root()//sl:stand[descendant::rg:Regelingsgebied]"/>
            <xsl:if test="$objects">
              <xsl:element name="Bestand" namespace="{$manifest}">
                <xsl:element name="naam" namespace="{$manifest}">
                  <xsl:value-of select="string('owRegelingsgebied.xml')"/>
                </xsl:element>
                <xsl:for-each select="('Regelingsgebied')">
                  <xsl:element name="objecttype" namespace="{$manifest}">
                    <xsl:value-of select="."/>
                  </xsl:element>
                </xsl:for-each>
              </xsl:element>
            </xsl:if>
          </xsl:element>
        </xsl:for-each>
      </xsl:element>
    </xsl:result-document>
  </xsl:template>

  <!-- owRegeltekst -->

  <xsl:template name="owRegeltekst">
    <xsl:param name="index"/>
    <xsl:param name="objects"/>
    <xsl:variable name="test" select="."/>
    <xsl:if test="$objects">
      <xsl:result-document href="{concat(fn:format-number($index,'000'),'-owRegeltekst.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="da" select="$da"/>
          <xsl:namespace name="ga" select="$ga"/>
          <xsl:namespace name="k" select="$k"/>
          <xsl:namespace name="l" select="$l"/>
          <xsl:namespace name="ow" select="$ow"/>
          <xsl:namespace name="ow-dc" select="$ow-dc"/>
          <xsl:namespace name="p" select="$p"/>
          <xsl:namespace name="r" select="$r"/>
          <xsl:namespace name="rg" select="$rg"/>
          <xsl:namespace name="rol" select="$rol"/>
          <xsl:namespace name="sl" select="$sl"/>
          <xsl:namespace name="vt" select="$vt"/>
          <xsl:namespace name="xlink" select="$xlink"/>
          <xsl:namespace name="xsi" select="$xsi"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select="(.//sl:standBestand/sl:dataset)[1]"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select="(.//sl:standBestand/sl:inhoud/sl:gebied)[1]"/>
              <xsl:apply-templates select="(.//sl:standBestand/sl:inhoud/sl:leveringsId)[1]"/>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Regeltekst')"/>
                </xsl:element>
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('RegelVoorIedereen')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="$objects"/>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="r:Regeltekst">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="(ancestor::tekst:Lid,ancestor::tekst:Artikel[not(tekst:Lid)],ancestor::tekst:Artikel[tekst:Lid]/tekst:Lid[1])[1]/@wId"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- owDivisie -->

  <xsl:template name="owDivisie">
    <xsl:param name="index"/>
    <xsl:param name="objects"/>
    <xsl:if test="$objects">
      <xsl:result-document href="{concat(fn:format-number($index,'000'),'-owDivisie.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="da" select="$da"/>
          <xsl:namespace name="ga" select="$ga"/>
          <xsl:namespace name="k" select="$k"/>
          <xsl:namespace name="l" select="$l"/>
          <xsl:namespace name="ow" select="$ow"/>
          <xsl:namespace name="ow-dc" select="$ow-dc"/>
          <xsl:namespace name="p" select="$p"/>
          <xsl:namespace name="r" select="$r"/>
          <xsl:namespace name="rg" select="$rg"/>
          <xsl:namespace name="rol" select="$rol"/>
          <xsl:namespace name="sl" select="$sl"/>
          <xsl:namespace name="vt" select="$vt"/>
          <xsl:namespace name="xlink" select="$xlink"/>
          <xsl:namespace name="xsi" select="$xsi"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select="(.//sl:standBestand/sl:dataset)[1]"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select="(.//sl:standBestand/sl:inhoud/sl:gebied)[1]"/>
              <xsl:apply-templates select="(.//sl:standBestand/sl:inhoud/sl:leveringsId)[1]"/>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Divisie')"/>
                </xsl:element>
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Divisietekst')"/>
                </xsl:element>
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Tekstdeel')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="$objects"/>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="vt:Divisie">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="ancestor::tekst:Divisie[1]/@wId"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="vt:Divisietekst">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="ancestor::tekst:Divisietekst[1]/@wId"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- owActiviteit -->

  <xsl:template name="owActiviteit">
    <xsl:param name="index"/>
    <xsl:param name="objects"/>
    <xsl:if test="$objects">
      <xsl:result-document href="{concat(fn:format-number($index,'000'),'-owActiviteit.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="da" select="$da"/>
          <xsl:namespace name="ga" select="$ga"/>
          <xsl:namespace name="k" select="$k"/>
          <xsl:namespace name="l" select="$l"/>
          <xsl:namespace name="ow" select="$ow"/>
          <xsl:namespace name="ow-dc" select="$ow-dc"/>
          <xsl:namespace name="p" select="$p"/>
          <xsl:namespace name="r" select="$r"/>
          <xsl:namespace name="rg" select="$rg"/>
          <xsl:namespace name="rol" select="$rol"/>
          <xsl:namespace name="sl" select="$sl"/>
          <xsl:namespace name="vt" select="$vt"/>
          <xsl:namespace name="xlink" select="$xlink"/>
          <xsl:namespace name="xsi" select="$xsi"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select=".//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:leveringsId"/>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Activiteit')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="$objects"/>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- owGebiedsaanwijzing -->

  <xsl:template name="owGebiedsaanwijzing">
    <xsl:param name="index"/>
    <xsl:param name="objects"/>
    <xsl:if test="$objects">
      <xsl:result-document href="{concat(fn:format-number($index,'000'),'-owGebiedsaanwijzing.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="da" select="$da"/>
          <xsl:namespace name="ga" select="$ga"/>
          <xsl:namespace name="k" select="$k"/>
          <xsl:namespace name="l" select="$l"/>
          <xsl:namespace name="ow" select="$ow"/>
          <xsl:namespace name="ow-dc" select="$ow-dc"/>
          <xsl:namespace name="p" select="$p"/>
          <xsl:namespace name="r" select="$r"/>
          <xsl:namespace name="rg" select="$rg"/>
          <xsl:namespace name="rol" select="$rol"/>
          <xsl:namespace name="sl" select="$sl"/>
          <xsl:namespace name="vt" select="$vt"/>
          <xsl:namespace name="xlink" select="$xlink"/>
          <xsl:namespace name="xsi" select="$xsi"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select=".//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:leveringsId"/>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Gebiedsaanwijzing')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="$objects"/>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- owHoofdlijn -->

  <xsl:template name="owHoofdlijn">
    <xsl:param name="index"/>
    <xsl:param name="objects"/>
    <xsl:if test="$objects">
      <xsl:result-document href="{concat(fn:format-number($index,'000'),'-owHoofdlijn.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="da" select="$da"/>
          <xsl:namespace name="ga" select="$ga"/>
          <xsl:namespace name="k" select="$k"/>
          <xsl:namespace name="l" select="$l"/>
          <xsl:namespace name="ow" select="$ow"/>
          <xsl:namespace name="ow-dc" select="$ow-dc"/>
          <xsl:namespace name="p" select="$p"/>
          <xsl:namespace name="r" select="$r"/>
          <xsl:namespace name="rg" select="$rg"/>
          <xsl:namespace name="rol" select="$rol"/>
          <xsl:namespace name="sl" select="$sl"/>
          <xsl:namespace name="vt" select="$vt"/>
          <xsl:namespace name="xlink" select="$xlink"/>
          <xsl:namespace name="xsi" select="$xsi"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select=".//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:leveringsId"/>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Hoofdlijn')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="$objects"/>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- owOmgevingsnorm -->

  <xsl:template name="owOmgevingsnorm">
    <xsl:param name="index"/>
    <xsl:param name="objects"/>
    <xsl:if test="$objects">
      <xsl:result-document href="{concat(fn:format-number($index,'000'),'-owOmgevingsnorm.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="da" select="$da"/>
          <xsl:namespace name="ga" select="$ga"/>
          <xsl:namespace name="k" select="$k"/>
          <xsl:namespace name="l" select="$l"/>
          <xsl:namespace name="ow" select="$ow"/>
          <xsl:namespace name="ow-dc" select="$ow-dc"/>
          <xsl:namespace name="p" select="$p"/>
          <xsl:namespace name="r" select="$r"/>
          <xsl:namespace name="rg" select="$rg"/>
          <xsl:namespace name="rol" select="$rol"/>
          <xsl:namespace name="sl" select="$sl"/>
          <xsl:namespace name="vt" select="$vt"/>
          <xsl:namespace name="xlink" select="$xlink"/>
          <xsl:namespace name="xsi" select="$xsi"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select=".//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:leveringsId"/>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Omgevingsnorm')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="$objects"/>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- owOmgevingswaarde -->

  <xsl:template name="owOmgevingswaarde">
    <xsl:param name="index"/>
    <xsl:param name="objects"/>
    <xsl:if test="$objects">
      <xsl:result-document href="{concat(fn:format-number($index,'000'),'-owOmgevingswaarde.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="da" select="$da"/>
          <xsl:namespace name="ga" select="$ga"/>
          <xsl:namespace name="k" select="$k"/>
          <xsl:namespace name="l" select="$l"/>
          <xsl:namespace name="ow" select="$ow"/>
          <xsl:namespace name="ow-dc" select="$ow-dc"/>
          <xsl:namespace name="p" select="$p"/>
          <xsl:namespace name="r" select="$r"/>
          <xsl:namespace name="rg" select="$rg"/>
          <xsl:namespace name="rol" select="$rol"/>
          <xsl:namespace name="sl" select="$sl"/>
          <xsl:namespace name="vt" select="$vt"/>
          <xsl:namespace name="xlink" select="$xlink"/>
          <xsl:namespace name="xsi" select="$xsi"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select=".//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:leveringsId"/>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Omgevingswaarde')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="$objects"/>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- owLocatie -->

  <xsl:template name="owLocatie">
    <xsl:param name="index"/>
    <xsl:param name="objects"/>
    <xsl:if test="$objects">
      <xsl:result-document href="{concat(fn:format-number($index,'000'),'-owLocatie.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="da" select="$da"/>
          <xsl:namespace name="ga" select="$ga"/>
          <xsl:namespace name="k" select="$k"/>
          <xsl:namespace name="l" select="$l"/>
          <xsl:namespace name="ow" select="$ow"/>
          <xsl:namespace name="ow-dc" select="$ow-dc"/>
          <xsl:namespace name="p" select="$p"/>
          <xsl:namespace name="r" select="$r"/>
          <xsl:namespace name="rg" select="$rg"/>
          <xsl:namespace name="rol" select="$rol"/>
          <xsl:namespace name="sl" select="$sl"/>
          <xsl:namespace name="vt" select="$vt"/>
          <xsl:namespace name="xlink" select="$xlink"/>
          <xsl:namespace name="xsi" select="$xsi"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select=".//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:leveringsId"/>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Ambtsgebied')"/>
                </xsl:element>
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Gebied')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="$objects"/>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- owRegelingsgebied -->

  <xsl:template name="owRegelingsgebied">
    <xsl:param name="index"/>
    <xsl:param name="objects"/>
    <xsl:if test="$objects">
      <xsl:result-document href="{concat(fn:format-number($index,'000'),'-owRegelingsgebied.xml')}" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="da" select="$da"/>
          <xsl:namespace name="ga" select="$ga"/>
          <xsl:namespace name="k" select="$k"/>
          <xsl:namespace name="l" select="$l"/>
          <xsl:namespace name="ow" select="$ow"/>
          <xsl:namespace name="ow-dc" select="$ow-dc"/>
          <xsl:namespace name="p" select="$p"/>
          <xsl:namespace name="r" select="$r"/>
          <xsl:namespace name="rg" select="$rg"/>
          <xsl:namespace name="rol" select="$rol"/>
          <xsl:namespace name="sl" select="$sl"/>
          <xsl:namespace name="vt" select="$vt"/>
          <xsl:namespace name="xlink" select="$xlink"/>
          <xsl:namespace name="xsi" select="$xsi"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="{$xsi}" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v2.0.0/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select=".//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select=".//sl:standBestand/sl:inhoud/sl:leveringsId"/>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Regelingsgebied')"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
            <xsl:apply-templates select="$objects"/>
          </xsl:element>
        </xsl:element>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <!-- OP -->

  <xsl:template name="AanleveringBesluit">
    <xsl:if test="//lvbb:AanleveringBesluit">
      <xsl:variable name="resultaat" select="//lvbb:publicatieOpdracht/lvbb:publicatie"/>
      <xsl:result-document href="{$resultaat}" method="xml">
        <xsl:apply-templates select="//lvbb:AanleveringBesluit"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ow-dc:owBestand">
    <!-- doe niets -->
  </xsl:template>

  <xsl:template match="tekst:IntIoRef">
    <xsl:variable name="noemer" select="lower-case(.)"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="$unique_geometrie/gio[./noemer=$noemer]">
          <xsl:attribute name="ref" select="$unique_geometrie/gio[./noemer=$noemer]/wId"/>
          <xsl:apply-templates select="node()"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:comment><xsl:text>diagnose: controleer de koppeling naar ExtIoRef</xsl:text></xsl:comment>
          <xsl:apply-templates select="node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <xsl:template match="data:BeoogdInformatieobject/data:eId">
    <xsl:variable name="join" select="parent::data:BeoogdInformatieobject/data:instrumentVersie"/>
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:choose>
        <xsl:when test="($unique_geometrie/gio[./join=$join]/eId)[1] ne ''">
          <xsl:value-of select="concat('!initieel_reg#',($unique_geometrie/gio[./join=$join]/eId)[1])"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:comment><xsl:text>diagnose: controleer de koppeling naar ExtIoRef</xsl:text></xsl:comment>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

  <!-- algemeen -->

  <xsl:template match="element()">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="comment()">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="@xlink:href">
    <xsl:copy-of select="."/>
  </xsl:template>

</xsl:stylesheet>