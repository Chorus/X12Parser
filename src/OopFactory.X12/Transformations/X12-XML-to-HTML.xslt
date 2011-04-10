﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

  <xsl:template name="Component">
    <xsl:param name="element"/>
    <xsl:for-each select="$element/*"><xsl:if test="position() != 1">:</xsl:if><xsl:value-of select="."/></xsl:for-each>
  </xsl:template>
  
  <xsl:template name="Element">
    <xsl:param name="element"/>
    <span class="element">*<xsl:choose>
      <xsl:when test="count($element/*) = 0"><xsl:value-of select="$element"/></xsl:when>
      <xsl:otherwise>        
        <xsl:call-template name="Component">
          <xsl:with-param name="element" select="$element"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template name="Segment">
    <xsl:param name="seg"/>
    <xsl:variable name="segId" select="name()" />
    <div class="segment">
      <xsl:choose>
        <xsl:when test="position() = 1">
          <xsl:attribute name="style">font-weight: bold;</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="style">margin-left: 25px;</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$segId"/><xsl:for-each select="*">
        <xsl:call-template name="Element">
          <xsl:with-param name="element" select="."/>
        </xsl:call-template>
      </xsl:for-each>~</div>
  </xsl:template>
  
  <xsl:template match="Loop">
    <div class="loop" style="border-left: 1px dotted gray; border-top: 1px dotted gray; margin-left: 20px;">
      <xsl:attribute name="title">Loop ID: <xsl:value-of select="@LoopId"/>, <xsl:value-of select="@Name"/></xsl:attribute>
      <xsl:for-each select="*[name()!='Loop']">
        <xsl:call-template name="Segment">
          <xsl:with-param name="seg" select="."/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:apply-templates select="Loop"/>
    </div>
  </xsl:template>

  <xsl:template match="HierarchicalLoop">
    <div class="hierarchical-loop" style="border-left: 2px solid black; border-top: 2px solid black; margin-left: 20px;">
      <xsl:attribute name="title">Loop ID: <xsl:value-of select="@LoopId"/>, <xsl:value-of select="@Name"/></xsl:attribute>
      <xsl:for-each select="*[name()!='Loop' and name()!='HierarchicalLoop']">
        <xsl:call-template name="Segment">
          <xsl:with-param name="seg" select="."/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:apply-templates select="Loop"/>
      <xsl:apply-templates select="HierarchicalLoop"/>
    </div>
  </xsl:template>
  <xsl:template match="Transaction">
    <div class="transaction" style="border: 1px solid gray; margin-left: 20px;">
      <xsl:for-each select="*[name()!='Loop' and name()!='HierarchicalLoop' and name()!='SE']">
        <xsl:call-template name="Segment">
          <xsl:with-param name="seg" select="."/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:apply-templates select="Loop"/>
      <xsl:apply-templates select="HierarchicalLoop"/>
      <xsl:for-each select="*[name()='SE']">
        <xsl:call-template name="Segment">
          <xsl:with-param name="seg" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="FunctionGroup">
    <div class="function-group" style="margin-left: 20px;">
      <xsl:for-each select="*[name()='GS']">
        <xsl:call-template name="Segment">
          <xsl:with-param name="seg" select="."/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:apply-templates select="Transaction"/>
      <xsl:for-each select="*[name()='GE']">
        <xsl:call-template name="Segment">
          <xsl:with-param name="seg" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="Interchange">
    <div class="interchange">
      <xsl:for-each select="*[name()='ISA']">
        <xsl:call-template name="Segment">
          <xsl:with-param name="seg" select="."/>
        </xsl:call-template>
      </xsl:for-each>
      <xsl:apply-templates select="FunctionGroup"/>
      <xsl:for-each select="*[name()='IEA']">
        <xsl:call-template name="Segment">
          <xsl:with-param name="seg" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </div>
  </xsl:template>


</xsl:stylesheet>