<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sql="http://apache.org/cocoon/SQL/2.0"
 xmlns:cmc2-f="http://www.philips.com/cmc2-f" extension-element-prefixes="cmc2-f" >
  <xsl:param name="ct"/>
  <xsl:param name="ts"/>
  <xsl:param name="reload"/>

  <xsl:include href="../../../xsl/common/cmc2.function.xsl"/>
  
  <xsl:variable name="countriesToConvertMetricToEmpirical">
    <country>US</country>
  </xsl:variable>
      
  <!--+
      | Convert the LogisticData from CCR to the format that is also supplied by
      | PFS.
      +-->
  <!-- Product dimensions chapter: not available -->
  <!-- Packaging dimensions chapter -->
  <xsl:template match="LogisticData/CTI" mode="generateCSChapters">
    <CSChapter>
      <CSChapterCode>CH4000342</CSChapterCode>
      <CSChapterName>Packaging dimensions</CSChapterName>
      <CSChapterRank>51</CSChapterRank>
      <xsl:apply-templates select="@*|node()"/>
    </CSChapter>
  </xsl:template>
  <xsl:template match="CTI/Height">
    <CSItem>
      <CSItemCode>IT4001441</CSItemCode>
      <CSItemName>Height</CSItemName>
      <CSItemRank>2</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004060</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="CTI/Width">
    <CSItem>
      <CSItemCode>IT4001439</CSItemCode>
      <CSItemName>Width</CSItemName>
      <CSItemRank>13</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004058</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="CTI/Depth">
    <CSItem>
      <CSItemCode>IT4001443</CSItemCode>
      <CSItemName>Depth</CSItemName>
      <CSItemRank>19</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004062</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="CTI/WeightNett">
    <CSItem>
      <CSItemCode>IT4001445</CSItemCode>
      <CSItemName>Net weight</CSItemName>
      <CSItemRank>22</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004064</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000049</UnitOfMeasureCode>
        <UnitOfMeasureName>kilogram</UnitOfMeasureName>
        <UnitOfMeasureSymbol>kg</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="CTI/WeightGross">
    <CSItem>
      <CSItemCode>IT4001447</CSItemCode>
      <CSItemName>Gross weight</CSItemName>
      <CSItemRank>26</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004066</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000049</UnitOfMeasureCode>
        <UnitOfMeasureName>kilogram</UnitOfMeasureName>
        <UnitOfMeasureSymbol>kg</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="CTI/@GTIN">
    <CSItem>
      <CSItemCode>IT4001451</CSItemCode>
      <CSItemName>EAN</CSItemName>
      <CSItemRank>32</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004070</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="CTI/NrOfItems">
    <CSItem>
      <CSItemCode>IT4001453</CSItemCode>
      <CSItemName>Number of products included</CSItemName>
      <CSItemRank>35</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004072</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="CTI/CountryOfOrigin">
    <CSItem>
      <CSItemCode>LDIT9990001</CSItemCode>
      <CSItemName>Country of origin</CSItemName>
      <CSItemRank>42</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>LDVA9990001</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="CTI/HSCode">
    <CSItem>
      <CSItemCode>LDIT9990002</CSItemCode>
      <CSItemName>Harmonised Systems Code</CSItemName>
      <CSItemRank>50</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>LDVA9990002</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  
  <!-- Inner Carton chapter -->
  <xsl:template match="LogisticData/InnerCarton1" mode="generateCSChapters">
    <CSChapter>
      <CSChapterCode>CH4000344</CSChapterCode>
      <CSChapterName>Inner Carton</CSChapterName>
      <CSChapterRank>52</CSChapterRank>
      <xsl:apply-templates select="@*|node()"/>
    </CSChapter>
  </xsl:template>
  <xsl:template match="InnerCarton1/NrOfCTI">
    <CSItem>
      <CSItemCode>IT4001487</CSItemCode>
      <CSItemName>Number of consumer packages</CSItemName>
      <CSItemRank>3</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003670</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="InnerCarton1/Depth">
    <CSItem>
      <CSItemCode>IT4001472</CSItemCode>
      <CSItemName>Length</CSItemName>
      <CSItemRank>8</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003655</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="InnerCarton1/Width">
    <CSItem>
      <CSItemCode>IT4001474</CSItemCode>
      <CSItemName>Width</CSItemName>
      <CSItemRank>14</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003657</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="InnerCarton1/Height">
    <CSItem>
      <CSItemCode>IT4001476</CSItemCode>
      <CSItemName>Height</CSItemName>
      <CSItemRank>17</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003659</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="InnerCarton1/WeightGross">
    <CSItem>
      <CSItemCode>IT4001480</CSItemCode>
      <CSItemName>Gross weight</CSItemName>
      <CSItemRank>24</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003663</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000049</UnitOfMeasureCode>
        <UnitOfMeasureName>kilogram</UnitOfMeasureName>
        <UnitOfMeasureSymbol>kg</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="InnerCarton1/@GTIN">
    <CSItem>
      <CSItemCode>IT4001486</CSItemCode>
      <CSItemName>GTIN</CSItemName>
      <CSItemRank>36</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003669</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>

  <!-- Inner Carton 2 chapter -->
  <xsl:template match="LogisticData/InnerCarton2" mode="generateCSChapters">
    <CSChapter>
      <CSChapterCode>CH4000345</CSChapterCode>
      <CSChapterName>Inner Carton 2</CSChapterName>
      <CSChapterRank>53</CSChapterRank>
      <xsl:apply-templates select="@*|node()"/>
    </CSChapter>
  </xsl:template>
  <xsl:template match="InnerCarton2/NrOfCTI">
    <CSItem>
      <CSItemCode>IT4001503</CSItemCode>
      <CSItemName>Number of consumer packages</CSItemName>
      <CSItemRank>3</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003686</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="InnerCarton2/Depth">
    <CSItem>
      <CSItemCode>IT4001488</CSItemCode>
      <CSItemName>Length</CSItemName>
      <CSItemRank>8</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004655</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="InnerCarton2/Width">
    <CSItem>
      <CSItemCode>IT4001490</CSItemCode>
      <CSItemName>Width</CSItemName>
      <CSItemRank>14</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004657</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="InnerCarton2/Height">
    <CSItem>
      <CSItemCode>IT4001492</CSItemCode>
      <CSItemName>Height</CSItemName>
      <CSItemRank>17</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004659</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="InnerCarton2/WeightGross">
    <CSItem>
      <CSItemCode>IT4001496</CSItemCode>
      <CSItemName>Gross weight</CSItemName>
      <CSItemRank>24</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004663</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000049</UnitOfMeasureCode>
        <UnitOfMeasureName>kilogram</UnitOfMeasureName>
        <UnitOfMeasureSymbol>kg</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="InnerCarton2/@GTIN">
    <CSItem>
      <CSItemCode>IT4001502</CSItemCode>
      <CSItemName>GTIN</CSItemName>
      <CSItemRank>36</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4004669</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  
  <!-- Outer Carton chapter -->
  <xsl:template match="LogisticData/OuterCarton" mode="generateCSChapters">
    <CSChapter>
      <CSChapterCode>CH4000343</CSChapterCode>
      <CSChapterName>Outer Carton</CSChapterName>
      <CSChapterRank>54</CSChapterRank>
      <xsl:apply-templates select="@*|node()"/>
    </CSChapter>
  </xsl:template>
  <xsl:template match="OuterCarton/Depth">
    <CSItem>
      <CSItemCode>IT4001456</CSItemCode>
      <CSItemName>Length</CSItemName>
      <CSItemRank>4</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003639</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="OuterCarton/Width">
    <CSItem>
      <CSItemCode>IT4001458</CSItemCode>
      <CSItemName>Width</CSItemName>
      <CSItemRank>15</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003641</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="OuterCarton/Height">
    <CSItem>
      <CSItemCode>IT4001460</CSItemCode>
      <CSItemName>Height</CSItemName>
      <CSItemRank>20</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003643</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="OuterCarton/WeightNett">
    <CSItem>
      <CSItemCode>IT4001462</CSItemCode>
      <CSItemName>Net weight</CSItemName>
      <CSItemRank>23</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003645</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000049</UnitOfMeasureCode>
        <UnitOfMeasureName>kilogram</UnitOfMeasureName>
        <UnitOfMeasureSymbol>kg</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="OuterCarton/WeightGross">
    <CSItem>
      <CSItemCode>IT4001464</CSItemCode>
      <CSItemName>Gross weight</CSItemName>
      <CSItemRank>27</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003647</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000049</UnitOfMeasureCode>
        <UnitOfMeasureName>kilogram</UnitOfMeasureName>
        <UnitOfMeasureSymbol>kg</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="OuterCarton/@GTIN">
    <CSItem>
      <CSItemCode>IT4001468</CSItemCode>
      <CSItemName>EAN</CSItemName>
      <CSItemRank>33</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003651</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="OuterCarton/NrOfCTI">
    <CSItem>
      <CSItemCode>IT4001471</CSItemCode>
      <CSItemName>Number of consumer packages</CSItemName>
      <CSItemRank>34</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode>VA4003654</CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>

  <!--+
      | Create dynamic chapters for each supplied loading unit.
      +-->
  <xsl:template match="LoadingUnit" mode="generateCSChapters">
    <xsl:variable name="baseItemCode" select="concat('IT', @Type, 'LU')"/>
    <xsl:variable name="baseValueCode" select="concat('VA', @Type, 'LU')"/>
    <CSChapter>
      <CSChapterCode>
        <xsl:value-of select="concat('CH', @Type,'LU')"/>
      </CSChapterCode>
      <CSChapterName>
        <xsl:value-of select="concat('Loading unit type ', @Type)"/>
      </CSChapterName>
      <CSChapterRank>
        <xsl:value-of select="55 + position()"/>
      </CSChapterRank>
      <xsl:apply-templates select="@*|node()">
        <xsl:with-param name="baseItemCode" select="$baseItemCode"/>
        <xsl:with-param name="baseValueCode" select="$baseValueCode"/>
      </xsl:apply-templates>
    </CSChapter>
  </xsl:template>
  <xsl:template match="LoadingUnit/NrOfCTI">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">471</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>Number of consumer packages</CSItemName>
      <CSItemRank>3</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="LoadingUnit/Depth">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">456</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>Length</CSItemName>
      <CSItemRank>8</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="LoadingUnit/Width">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">458</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>Width</CSItemName>
      <CSItemRank>14</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="LoadingUnit/Height">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">460</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>Height</CSItemName>
      <CSItemRank>17</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000039</UnitOfMeasureCode>
        <UnitOfMeasureName>centimetre</UnitOfMeasureName>
        <UnitOfMeasureSymbol>cm</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="LoadingUnit/WeightGross">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">464</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>Gross weight</CSItemName>
      <CSItemRank>24</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000049</UnitOfMeasureCode>
        <UnitOfMeasureName>kilogram</UnitOfMeasureName>
        <UnitOfMeasureSymbol>kg</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="LoadingUnit/WeightNett">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">462</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>Gross weight</CSItemName>
      <CSItemRank>36</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
      <UnitOfMeasure>
        <UnitOfMeasureCode>3000049</UnitOfMeasureCode>
        <UnitOfMeasureName>kilogram</UnitOfMeasureName>
        <UnitOfMeasureSymbol>kg</UnitOfMeasureSymbol>
      </UnitOfMeasure>
    </CSItem>
  </xsl:template>
  <xsl:template match="LoadingUnit/@GTIN">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">000</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>GTIN</CSItemName>
      <CSItemRank>42</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="LoadingUnit/@Type">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">001</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>Type</CSItemName>
      <CSItemRank>56</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="LoadingUnit/NrOfCTIsPerStacklayer">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">467</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>Number of CTIs per stack layer</CSItemName>
      <CSItemRank>68</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="LoadingUnit/NrOfStacklayersPerUnit">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">465</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>Number of stack layers per unit</CSItemName>
      <CSItemRank>80</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  <xsl:template match="LoadingUnit/NrOfOuterCartonsPerLayer">
    <xsl:param name="baseItemCode"/>
    <xsl:param name="baseValueCode"/>
    <xsl:variable name="itemId">466</xsl:variable>
    <CSItem>
      <CSItemCode><xsl:value-of select="concat($baseItemCode, $itemId)"/></CSItemCode>
      <CSItemName>Number of outer cartons per layer</CSItemName>
      <CSItemRank>92</CSItemRank>
      <CSItemIsFreeFormat>1</CSItemIsFreeFormat>
      <CSValue>
        <CSValueCode><xsl:value-of select="concat($baseValueCode, $itemId, 1)"/></CSValueCode>
        <CSValueName><xsl:value-of select="."/></CSValueName>
        <CSValueRank>1</CSValueRank>
      </CSValue>
    </CSItem>
  </xsl:template>
  
  <!--+
      | Copy all elements when convert the unit of measurements.
      +-->
  <xsl:template match="*" mode="convertUoMs">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*|node()" mode="convertUoMs"/>
    </xsl:copy>
  </xsl:template>
  
  <!--+
      | Convert the unit of measurements turning centimeters to inches and
      | kilograms to pounds.
      +-->
  <xsl:template match="CSItem[UnitOfMeasure]" mode="convertUoMs">
    <CSItem>
      <xsl:apply-templates select="*[not(name() = ('CSValue', 'UnitOfMeasure'))]" mode="convertUoMs"/>
      <xsl:variable name="converstionRatio">
        <xsl:choose>
          <!-- cm -> in -->
          <xsl:when test="UnitOfMeasure/UnitOfMeasureCode = '3000039'">0.393701</xsl:when>
          <!-- kg -> lb -->
          <xsl:when test="UnitOfMeasure/UnitOfMeasureCode = '3000049'">2.20462</xsl:when>
          <!-- default: identity -->
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- Apply the conversion ratio to the value  -->
      <CSValue>
        <xsl:copy-of select="CSValue/CSValueCode"/>
        <CSValueName>
          <xsl:value-of select="$converstionRatio * CSValue/CSValueName"/>
        </CSValueName>
        <xsl:copy-of select="CSValue/CSValueRank"/>
      </CSValue>
      <!-- Add the replacement unit of measurement -->
      <xsl:choose>
        <!-- cm -> in -->
        <xsl:when test="UnitOfMeasure/UnitOfMeasureCode = '3000039'">
          <UnitOfMeasure>
            <UnitOfMeasureCode>3000047</UnitOfMeasureCode>
            <UnitOfMeasureName>inch</UnitOfMeasureName>
            <UnitOfMeasureSymbol>inch</UnitOfMeasureSymbol>
          </UnitOfMeasure>
        </xsl:when>
        <!-- kg -> lb -->
        <xsl:when test="UnitOfMeasure/UnitOfMeasureCode = '3000049'">
          <UnitOfMeasure>
            <UnitOfMeasureCode>3000068</UnitOfMeasureCode>
            <UnitOfMeasureName>pound</UnitOfMeasureName>
            <UnitOfMeasureSymbol>lb</UnitOfMeasureSymbol>
          </UnitOfMeasure>
        </xsl:when>
        <!-- default: identity -->
        <xsl:otherwise>
          <xsl:copy-of select="*[name() = 'UnitOfMeasure']"/>
        </xsl:otherwise>
      </xsl:choose>
    </CSItem>
  </xsl:template>

  <xsl:template match="Product">
    <xsl:variable name="l" select="concat('master_', Country)"/>
    <entry o="{CTN}" ct="{$ct}" l="{$l}" valid="true">
      <result>OK</result>
      <content>
        <LogisticData>
          <xsl:variable name="logisticCSChapters">
            <xsl:apply-templates select="LogisticData/*" mode="generateCSChapters"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$countriesToConvertMetricToEmpirical/country = Country">
              <xsl:apply-templates select="$logisticCSChapters" mode="convertUoMs"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$logisticCSChapters"/>
            </xsl:otherwise>
          </xsl:choose>
        </LogisticData>
      </content>
      <currentmasterlastmodified_ts>
        <sql:execute-query>
          <sql:query>
            select TO_CHAR(masterlastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') masterlastmodified_ts
              from octl
             where content_type = '<xsl:value-of select="$ct"/>'
               and localisation = '<xsl:value-of select="$l"/>'
               and object_id = '<xsl:value-of select="CTN"/>'
          </sql:query>
        </sql:execute-query>
      </currentmasterlastmodified_ts>
      <currentlastmodified_ts>
        <sql:execute-query>
          <sql:query>
            select TO_CHAR(lastmodified_ts,'yyyy-mm-dd"T"hh24:mi:ss') lastmodified_ts                             
              from octl
             where content_type = '<xsl:value-of select="$ct"/>'
               and localisation = '<xsl:value-of select="$l"/>'
               and object_id = '<xsl:value-of select="CTN"/>'
          </sql:query>
        </sql:execute-query>
      </currentlastmodified_ts>
      <currentmarketingversion>
        <sql:execute-query>
          <sql:query>
            select marketingversion                             
              from octl
             where content_type = '<xsl:value-of select="$ct"/>'
               and localisation = '<xsl:value-of select="$l"/>'
               and object_id = '<xsl:value-of select="CTN"/>'
          </sql:query>
        </sql:execute-query>
      </currentmarketingversion> 	  
      <process/>
      <octl-attributes>
        <xsl:choose>
          <xsl:when test="not($reload='true')">
            <xsl:variable name="processTimestamp" select="cmc2-f:formatDate($ts)" />
            <lastmodified_ts>
              <xsl:value-of select="$processTimestamp"/>
            </lastmodified_ts>
            <!--+
                | Substitute process timestamp for timestamp in xml because PFS
                | is unable to determine changed product relations as a trigger
                | to update the product timestamp.
                +-->
            <masterlastmodified_ts>
              <xsl:value-of select="$processTimestamp"/>
            </masterlastmodified_ts>
          </xsl:when>
          <xsl:otherwise>
            <lastmodified_ts/>
            <masterlastmodified_ts/>
          </xsl:otherwise>          
        </xsl:choose>
        <status>Final Published</status>
        <marketingversion/>
      </octl-attributes>
    </entry>
  </xsl:template>
</xsl:stylesheet>
