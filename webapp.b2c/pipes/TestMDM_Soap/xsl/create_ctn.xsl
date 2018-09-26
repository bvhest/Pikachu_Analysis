<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:include="http://apache.org/cocoon/include/1.0">
  <xsl:param name="ctn" as="xs:string"/>
  <!-- -->
  <xsl:template match="/">
    <root>
      <ws:element xmlns:ws="http://apache.org/cocoon/webservice/1.0" soapAction="" endpoint="http://130.144.133.200:53000/MDMCreateRecords/Config1?style=document">
        <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema">
          <SOAP-ENV:Body>
            <pns:createRecords xmlns:pns="urn:MDMCreateRecordsVi">
              <ns1:records xmlns:ns1="urn:MDMCreateRecordsVi" xmlns:pns="urn:com.sap.ws.types.generic">
                <pns:Record>
                  <pns:dataElement>
                    <pns:field>
                      <pns:dataType>STRING</pns:dataType>
                      <pns:unifiedField>
                        <pns:code>CTN</pns:code>
                        <pns:fieldName>
                          <pns:language>English [US]</pns:language>
                          <pns:name>CTN</pns:name>
                        </pns:fieldName>
                      </pns:unifiedField>
                    </pns:field>
                    <pns:simpleValue>
                      <pns:position>0</pns:position>
                      <pns:unifiedValue>
                        <pns:unit/>
                        <pns:value>
                          <pns:language>English [US]</pns:language>
                          <pns:value><xsl:value-of select="$ctn"/></pns:value>
                        </pns:value>
                      </pns:unifiedValue>
                    </pns:simpleValue>
                  </pns:dataElement>
                  <pns:dataElement>
                    <pns:field>
                      <pns:dataType>STRING</pns:dataType>
                      <pns:unifiedField>
                        <pns:code>12NC</pns:code>
                        <pns:fieldName>
                          <pns:language>English [US]</pns:language>
                          <pns:name>12NC</pns:name>
                        </pns:fieldName>
                      </pns:unifiedField>
                    </pns:field>
                    <pns:simpleValue>
                      <pns:position>0</pns:position>
                      <pns:remoteKey>
                        <pns:clientSystem/>
                      </pns:remoteKey>
                      <pns:unifiedValue>
                        <pns:unit/>
                        <pns:value>
                          <pns:language>English [US]</pns:language>
                          <pns:value><xsl:value-of select="$ctn"/><xsl:text> 12NC</xsl:text></pns:value>
                        </pns:value>
                      </pns:unifiedValue>
                    </pns:simpleValue>
                  </pns:dataElement>
                  <pns:recordIdentifier>
                    <pns:externalId/>
                    <pns:recordId>0</pns:recordId>
                    <pns:remoteKey>
                      <pns:clientSystem/>
                    </pns:remoteKey>
                    <pns:table>
                      <pns:code>Products</pns:code>
                    </pns:table>
                  </pns:recordIdentifier>
                </pns:Record>
              </ns1:records>
              <ns2:repositoryInformation xmlns:ns2="urn:MDMCreateRecordsVi" xmlns:pns="urn:com.sap.ws.types.generic">
                <pns:dataLang>English [US]</pns:dataLang>
                <pns:repositoryName>Philips_NEW</pns:repositoryName>
                <pns:repositoryPort>2750</pns:repositoryPort>
                <pns:schemaLang>English [US]</pns:schemaLang>
                <pns:serverName>localhost</pns:serverName>
              </ns2:repositoryInformation>
              <ns3:configurationData xmlns:ns3="urn:MDMCreateRecordsVi" xmlns:pns="urn:com.sap.ws.types.generic"/>
            </pns:createRecords>
          </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
      </ws:element>
    </root>
  </xsl:template>
  <!-- -->
</xsl:stylesheet>
