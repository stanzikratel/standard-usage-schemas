<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns="http://wadl.dev.java.net/2009/02"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:sch="http://docs.rackspace.com/core/usage/schema"
    xmlns:rax="http://docs.rackspace.com/api"
    xmlns:event="http://docs.rackspace.com/core/event"
    xmlns:atom="http://www.w3.org/2005/Atom"
    exclude-result-prefixes="sch c"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="NS_PREFIX" select="'w_ns'"/>
    <!-- Event types, excepts for USAGE, which is a special case -->
    <xsl:variable name="EVENT_TYPES" as="xs:string*"
        select="('CREATE','USAGE_SNAPSHOT','UPDATE', 'DELETE', 'SUSPEND', 'UNSUSPEND', 'EXTENDED','UP','DOWN')"/>
    <xsl:template match="c:directory">
        <xsl:variable name="productSchemas" as="node()">
            <sch:productSchemas>
                <xsl:for-each select="c:file">
                    <sch:productSchema>
                       <xsl:attribute name="pos" select="position()"/>
                      <xsl:copy-of select="document(concat(base-uri(),'/',@name))/sch:productSchema/(* | @*)"/>
                    </sch:productSchema>
                </xsl:for-each>
            </sch:productSchemas>
        </xsl:variable>
        <xsl:comment>
            <xsl:text>&#x0a;    THIS WADL IS AUTOGENERATED DO NOT EDIT</xsl:text>
            <xsl:text>&#x0a;    GENERATED ON: </xsl:text><xsl:value-of select="current-dateTime()"/>
            <xsl:text>&#x0a;    PRODUCT SCHEMAS:</xsl:text>
            <xsl:for-each select="c:file">
                <xsl:text>&#x0a;           </xsl:text><xsl:value-of select="@name"/>
            </xsl:for-each>
            <xsl:text>&#x0a;</xsl:text>
        </xsl:comment>
        <xsl:text>&#x0a;</xsl:text>
        <application>
            <xsl:for-each select="$productSchemas//sch:productSchema">
                <xsl:namespace name="{sch:ns(@pos)}" select="@namespace"/>
            </xsl:for-each>
            <xsl:for-each-group select="$productSchemas//sch:productSchema" group-by="@serviceCode">
                <xsl:variable name="id" select="current-group()[1]/@serviceCode"/>
                <resource_type id="{$id}">
                    <method id="add{$id}Entry" name="POST">
                        <request>
                            <representation mediaType="application/atom+xml" element="atom:entry">
                                <xsl:call-template name="sch:param">
                                    <xsl:with-param name="type" select="'USAGE'"/>
                                    <xsl:with-param name="schemas" select="current-group()[not(@type) or ('USAGE' = tokenize(@type,' '))]"/>
                                </xsl:call-template>
                                <xsl:for-each select="$EVENT_TYPES">
                                    <xsl:variable name="type" select="."/>
                                    <xsl:call-template name="sch:param">
                                        <xsl:with-param name="type" select="."/>
                                        <xsl:with-param name="schemas" select="current-group()[$type = tokenize(@type,' ')]"/>
                                    </xsl:call-template>
                                </xsl:for-each>
                                <rax:preprocess href="atom_hopper_pre.xsl"/>
                            </representation>
                        </request>
                        <!-- Okay -->
                        <response status="201">
                            <representation mediaType="application/atom+xml"/>
                        </response>
                        <!-- On Error -->
                        <response status="400 401 409 500 503">
                            <representation mediaType="application/xml"/>
                        </response>
                    </method>
                </resource_type>
            </xsl:for-each-group>
        </application>
    </xsl:template>
    <xsl:template name="sch:param">
        <xsl:param name="schemas" as="node()*"/>
        <xsl:param name="type" as="xs:string"/>
        <xsl:variable name="isUsageEvent">/atom:entry/atom:content/event:event[@type='<xsl:value-of select="$type"/>']</xsl:variable>
        <xsl:if test="$schemas">
            <xsl:variable name="events" as="xs:string*">
                <xsl:for-each select="$schemas">
                    <xsl:value-of select="concat($isUsageEvent,'/',sch:ns(@pos),':product')"/>
                </xsl:for-each>
            </xsl:variable>
            <param name="{lower-case($type)}" style="plain" required="true">
                <xsl:attribute name="path">
                    <xsl:text>if (</xsl:text><xsl:value-of select="$isUsageEvent"/>
                    <xsl:text>) then (</xsl:text>
                    <xsl:value-of select='$events' separator=","/>
                    <xsl:text>) else true()</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="rax:message">
                    <xsl:text>Only </xsl:text><xsl:value-of select="lower-case($type)"/>
                    <xsl:text> messages with product attributes in the following namespaces are allowed in this feed: </xsl:text>
                    <xsl:value-of select="$schemas/@namespace" separator=", "/>
                </xsl:attribute>
            </param>
        </xsl:if>
    </xsl:template>
    <xsl:function name="sch:ns" as="xs:string">
        <xsl:param name="pos" as="xs:integer"/>
        <xsl:value-of select="concat($NS_PREFIX,$pos)"/>
    </xsl:function>
    <xsl:template match="text()" mode="#all"/>
</xsl:stylesheet>