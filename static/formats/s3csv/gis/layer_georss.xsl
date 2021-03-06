<?xml version="1.0"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- **********************************************************************
         GeoRSS Layers - CSV Import Stylesheet

         CSV column...........Format..........Content

         Name.................string..........Layer Name
         Description..........string..........Layer Description
         URL..................string..........Layer URL
         Marker...............string..........Layer Marker Name
         Enabled..............boolean.........Layer Enabled?
         Visible..............boolean.........Layer Visible?
         Folder...............string..........Layer Folder
         Image................string..........Layer Image

    *********************************************************************** -->
    <xsl:output method="xml"/>

    <!-- ****************************************************************** -->
    <!-- Indexes for faster processing -->
    <xsl:key name="markers" match="row" use="col[@field='Marker']/text()"/>

    <!-- ****************************************************************** -->
    <xsl:template match="/">
        <s3xml>
            <!-- Markers -->
            <xsl:for-each select="//row[generate-id(.)=generate-id(key('markers',
                                                                   col[@field='Marker'])[1])]">
                <xsl:call-template name="Marker"/>
            </xsl:for-each>

            <!-- GeoRSS Layers -->
            <xsl:apply-templates select="./table/row"/>
        </s3xml>
    </xsl:template>

    <!-- ****************************************************************** -->
    <xsl:template match="row">

        <xsl:variable name="Marker" select="col[@field='Marker']/text()"/>

        <resource name="gis_layer_georss">
            <data field="name"><xsl:value-of select="col[@field='Name']"/></data>
            <data field="description"><xsl:value-of select="col[@field='Description']"/></data>
            <data field="url"><xsl:value-of select="col[@field='URL']"/></data>
            <data field="enabled"><xsl:value-of select="col[@field='Enabled']"/></data>
            <data field="visible"><xsl:value-of select="col[@field='Visible']"/></data>
            <data field="dir"><xsl:value-of select="col[@field='Folder']"/></data>
            <data field="image"><xsl:value-of select="col[@field='Image']"/></data>
            <reference field="marker_id" resource="gis_marker">
                <xsl:attribute name="tuid">
                    <xsl:value-of select="$Marker"/>
                </xsl:attribute>
            </reference>
        </resource>
    </xsl:template>

    <!-- ****************************************************************** -->

    <xsl:template name="Marker">

        <xsl:variable name="Marker" select="col[@field='Marker']/text()"/>
    
        <resource name="gis_marker">
            <xsl:attribute name="tuid">
                <xsl:value-of select="$Marker"/>
            </xsl:attribute>
            <data field="name"><xsl:value-of select="$Marker"/></data>
        </resource>
    </xsl:template>

    <!-- ****************************************************************** -->

</xsl:stylesheet>
