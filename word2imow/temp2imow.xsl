<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:r="http://www.geostandaarden.nl/imow/regels" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:xlink="http://www.w3.org/1999/xlink">
  <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
  <xsl:strip-space elements="*"/>

  <xsl:template match="/">
    <xsl:call-template name="owRegeltekst"/>
    <xsl:call-template name="owDivisie"/>
    <xsl:call-template name="owActiviteit"/>
    <xsl:call-template name="owGebiedsaanwijzing"/>
    <xsl:call-template name="owHoofdlijn"/>
    <xsl:call-template name="owLocatie"/>
    <xsl:call-template name="owRegelingsgebied"/>
  </xsl:template>

  <!-- owRegeltekst -->

  <xsl:template name="owRegeltekst">
    <xsl:variable name="test" select="."/>
    <xsl:variable name="objects" select="//sl:stand[descendant::r:Regeltekst|descendant::r:RegelVoorIedereen]"/>
    <xsl:if test="$objects">
      <xsl:result-document href="owRegeltekst.xml" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
          <xsl:namespace name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
          <xsl:namespace name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
          <xsl:namespace name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
          <xsl:namespace name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
          <xsl:namespace name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
          <xsl:namespace name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
          <xsl:namespace name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
          <xsl:namespace name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
          <xsl:namespace name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
          <xsl:namespace name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
          <xsl:namespace name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
          <xsl:namespace name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
          <xsl:namespace name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select="//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:leveringsId"/>
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
      <xsl:copy-of select="(ancestor::Lid,ancestor::Artikel[not(Lid)],ancestor::Artikel[Lid]/Lid[1])[1]/@wId"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- owDivisie -->

  <xsl:template name="owDivisie">
    <xsl:variable name="objects" select="//sl:stand[descendant::vt:Divisie|descendant::vt:Tekstdeel]"/>
    <xsl:if test="$objects">
      <xsl:result-document href="owDivisie.xml" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
          <xsl:namespace name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
          <xsl:namespace name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
          <xsl:namespace name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
          <xsl:namespace name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
          <xsl:namespace name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
          <xsl:namespace name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
          <xsl:namespace name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
          <xsl:namespace name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
          <xsl:namespace name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
          <xsl:namespace name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
          <xsl:namespace name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
          <xsl:namespace name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
          <xsl:namespace name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select="//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:leveringsId"/>
              <xsl:element name="sl:objectTypen">
                <xsl:element name="sl:objectType">
                  <xsl:value-of select="string('Divisie')"/>
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
      <xsl:copy-of select="ancestor::Divisie[1]/@wId"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- owActiviteit -->

  <xsl:template name="owActiviteit">
    <xsl:variable name="objects" select="//sl:stand[descendant::rol:Activiteit]"/>
    <xsl:if test="$objects">
      <xsl:result-document href="owActiviteit.xml" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
          <xsl:namespace name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
          <xsl:namespace name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
          <xsl:namespace name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
          <xsl:namespace name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
          <xsl:namespace name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
          <xsl:namespace name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
          <xsl:namespace name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
          <xsl:namespace name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
          <xsl:namespace name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
          <xsl:namespace name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
          <xsl:namespace name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
          <xsl:namespace name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
          <xsl:namespace name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select="//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:leveringsId"/>
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
    <xsl:variable name="objects" select="//sl:stand[descendant::ga:Gebiedsaanwijzing]"/>
    <xsl:if test="$objects">
      <xsl:result-document href="owGebiedsaanwijzing.xml" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
          <xsl:namespace name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
          <xsl:namespace name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
          <xsl:namespace name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
          <xsl:namespace name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
          <xsl:namespace name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
          <xsl:namespace name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
          <xsl:namespace name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
          <xsl:namespace name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
          <xsl:namespace name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
          <xsl:namespace name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
          <xsl:namespace name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
          <xsl:namespace name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
          <xsl:namespace name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select="//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:leveringsId"/>
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
    <xsl:variable name="objects" select="//sl:stand[descendant::vt:Hoofdlijn]"/>
    <xsl:if test="$objects">
      <xsl:result-document href="owHoofdlijn.xml" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
          <xsl:namespace name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
          <xsl:namespace name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
          <xsl:namespace name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
          <xsl:namespace name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
          <xsl:namespace name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
          <xsl:namespace name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
          <xsl:namespace name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
          <xsl:namespace name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
          <xsl:namespace name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
          <xsl:namespace name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
          <xsl:namespace name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
          <xsl:namespace name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
          <xsl:namespace name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select="//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:leveringsId"/>
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

  <!-- owLocatie -->

  <xsl:template name="owLocatie">
    <xsl:variable name="objects" select="//sl:stand[descendant::l:Ambtsgebied,descendant::l:Gebied]"/>
    <xsl:if test="$objects">
      <xsl:result-document href="owLocatie.xml" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
          <xsl:namespace name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
          <xsl:namespace name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
          <xsl:namespace name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
          <xsl:namespace name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
          <xsl:namespace name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
          <xsl:namespace name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
          <xsl:namespace name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
          <xsl:namespace name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
          <xsl:namespace name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
          <xsl:namespace name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
          <xsl:namespace name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
          <xsl:namespace name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
          <xsl:namespace name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select="//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:leveringsId"/>
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
    <xsl:variable name="objects" select="//sl:stand[descendant::rg:Regelingsgebied]"/>
    <xsl:if test="$objects">
      <xsl:result-document href="owRegelingsgebied.xml" method="xml">
        <xsl:element name="ow-dc:owBestand">
          <xsl:namespace name="ow-dc" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand')"/>
          <xsl:namespace name="ow" select="string('http://www.geostandaarden.nl/imow/owobject')"/>
          <xsl:namespace name="da" select="string('http://www.geostandaarden.nl/imow/datatypenalgemeen')"/>
          <xsl:namespace name="sl" select="string('http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek')"/>
          <xsl:namespace name="ga" select="string('http://www.geostandaarden.nl/imow/gebiedsaanwijzing')"/>
          <xsl:namespace name="k" select="string('http://www.geostandaarden.nl/imow/kaart')"/>
          <xsl:namespace name="l" select="string('http://www.geostandaarden.nl/imow/locatie')"/>
          <xsl:namespace name="p" select="string('http://www.geostandaarden.nl/imow/pons')"/>
          <xsl:namespace name="r" select="string('http://www.geostandaarden.nl/imow/regels')"/>
          <xsl:namespace name="rg" select="string('http://www.geostandaarden.nl/imow/regelingsgebied')"/>
          <xsl:namespace name="rol" select="string('http://www.geostandaarden.nl/imow/regelsoplocatie')"/>
          <xsl:namespace name="vt" select="string('http://www.geostandaarden.nl/imow/vrijetekst')"/>
          <xsl:namespace name="xlink" select="string('http://www.w3.org/1999/xlink')"/>
          <xsl:namespace name="xsi" select="string('http://www.w3.org/2001/XMLSchema-instance')"/>
          <xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="string('http://www.geostandaarden.nl/imow/bestanden/deelbestand https://register.geostandaarden.nl/xmlschema/tpod/v1.0.3/bestanden-ow/deelbestand-ow/IMOW_Deelbestand.xsd')"/>
          <xsl:element name="sl:standBestand">
            <xsl:apply-templates select="//sl:standBestand/sl:dataset"/>
            <xsl:element name="sl:inhoud">
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:gebied"/>
              <xsl:apply-templates select="//sl:standBestand/sl:inhoud/sl:leveringsId"/>
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

  <!-- algemeen -->

  <xsl:template match="element()">
    <xsl:element name="{name()}">
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