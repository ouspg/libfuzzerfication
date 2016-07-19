<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:wsdl="http://www.w3.org/ns/wsdl"
    xmlns:wsoap="http://www.w3.org/ns/wsdl/soap"
    xmlns:whttp="http://www.w3.org/ns/wsdl/http"
    xmlns:wrpc="http://www.w3.org/ns/wsdl/rpc"
    xmlns:wsdlx="http://www.w3.org/ns/wsdl-extensions"
    xmlns="http://www.w3.org/2002/ws/desc/wsdl/component"
    xmlns:ext="http://www.w3.org/2002/ws/desc/wsdl/component-extensions"
    xmlns:base="http://www.w3.org/2002/ws/desc/wsdl/component-base"
    xmlns:httpcm="http://www.w3.org/2002/ws/desc/wsdl/component-http"
    xmlns:rpccm="http://www.w3.org/2002/ws/desc/wsdl/component-rpc"
    xmlns:soapcm="http://www.w3.org/2002/ws/desc/wsdl/component-soap"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:wsa="http://www.w3.org/2005/08/addressing"
    xmlns:wsam="http://www.w3.org/2007/05/addressing/metadata"
    xmlns:wsacm="http://www.w3.org/2002/ws/desc/wsdl/component-ws-addressing"
    xmlns:wsp="http://www.w3.org/ns/ws-policy"
    xmlns:wspcm="http://www.w3.org/2002/ws/desc/wsdl/component-ws-policy"
    xmlns:sawsdlcm="http://www.w3.org/2002/ws/desc/wsdl/component-sawsdl"
    xmlns:sawsdl="http://www.w3.org/2007/01/sawsdl#"
    exclude-result-prefixes="wsdl wsoap xs wsdlx wrpc whttp wsam wsa">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <!--
        Stylesheet to parse WSDL 2.0 documents into interchange format (wsdlcm)
        
        Created: March 27, 2006, Jonathan Marsh, WSO2 (formerly Microsoft).  jonathan@wso2.com
        
        ChangeLog:
        2006-12-01 Jonathan Marsh (jonathan@wso2.com)
        - added support for WS-Addressing 1.0 WSDL extensions (CR)
          http://www.w3.org/TR/2006/CR-ws-addr-wsdl-20060529/
        - ws-engaged parameter turns on/off WS-Addressing support.
        
        2006-11-17 Arthur Ryman (ryman@ca.ibm.com)
        - added xml:id="{generate-id(.)}" to SOAP Module and Header component elements
        - added httpHeader and httpContentEncoding to soapBindingFaultExtension by cut and paste
        	* Corrected spelling of whttp:headers to whttp:header
        	* Corrected namespace on parent to base:parent
        	* Jonathan - I suggest you make these named templates.
    
        Major todos:
          - suppress equivalent components (only multiply-imported components and 
            equivalent interface components are collapsed.
    -->
    <!--
        Note - limited levels of WSDL import/include functionality:
        Supported scenarios:
          - WSDL directly pointed to by wsdl:import/@location.
          - WSDL directly pointed to by wsdl:include/@location.
        Unsupported scenarios:
          - WSDL imported or included indirectly.
          - WSDL imported without a @location attribute (no catalog support).
    -->
    <xsl:param name="wsa-engaged" select="false"/>
    <xsl:param name="wsp-engaged" select="false"/>
    <xsl:param name="sawsdl-engaged" select="false"/>
    <xsl:variable name="root" select="/wsdl:description"/>
    <xsl:variable name="imported-wsdl"
        select="document($root[wsdl:include]/wsdl:include/@location)/wsdl:description |
                document($root[wsdl:import]/wsdl:import/@location)/wsdl:description"/>
    <!-- global (including imports/includes) collections of types that may be referred to later -->
    <xsl:variable name="all-interfaces" select="$root/wsdl:interface | $imported-wsdl/wsdl:interface"/>
    <xsl:variable name="all-operations" select="$all-interfaces/wsdl:operation"/>
    <xsl:variable name="all-faults" select="$all-interfaces/wsdl:fault"/>
    <xsl:variable name="all-bindings" select="$root/wsdl:binding | $imported-wsdl/wsdl:binding"/>
    <xsl:variable name="all-services" select="$root/wsdl:service| $imported-wsdl/wsdl:service"/>
    <!--
        Note - limited levels of Schema import/include functionality:
        Supported scenarios:
        - Embedded schemas (multiple schemas OK)
        - Schema directly pointed to by wsdl:types/xs:import/@schemaLocation.
        - Above scenarios, when resulting from direct import/include of WSDL.
        - Chameleon includes (namespace specified on the include, not in the included schema.)
        Unsupported scenarios:
        - Schema imported or included indirectly (except as above).
        - Schema imported without @schemaLocation attribute (no catalog support).
    -->
    <xsl:variable name="imported-schema"
        select="document($root/wsdl:types[xs:import]/xs:import[@schemaLocation and not(starts-with(@schemaLocation,'#'))]/@schemaLocation)/xs:schema |
        document($imported-wsdl/wsdl:types[xs:import]/xs:import[@schemaLocation and not(starts-with(@schemaLocation,'#'))]/@schemaLocation)/xs:schema |
        $imported-wsdl/wsdl:types/xs:schema"/>
    <xsl:variable name="included-schema"
        select="document($root/wsdl:types/xs:schema[xs:include]/xs:include/@schemaLocation)/xs:schema"/>
    <!-- global (including imports/includes) collections of types that may be referred to later -->
    <xsl:variable name="all-elements" 
        select="$root/wsdl:types/xs:schema/xs:element | 
                $imported-wsdl/wsdl:types/xs:schema/xs:element |
                $imported-schema/xs:element | 
                $included-schema/xs:element"/>
    <xsl:variable name="all-types" 
        select="$root/wsdl:types/xs:schema/xs:simpleType | 
        $imported-wsdl/wsdl:types/xs:schema/xs:simpleType |
        $imported-schema/xs:simpleType | 
        $included-schema/xs:simpleType |
        $root/wsdl:types/xs:schema/xs:complexType | 
        $imported-wsdl/wsdl:types/xs:schema/xs:complexType |
        $imported-schema/xs:complexType | 
        $included-schema/xs:complexType"/>
    <!-- 
        Template for the primary description element.
    -->
    <xsl:template match="wsdl:description">
        <xsl:comment> Generated by wsdl-component-model.xslt, Jonathan Marsh, WSO2, jonathan@wso2.com  </xsl:comment>
        <descriptionComponent xml:id="{generate-id(.)}">
            <extensions>
                <base:uri>http://www.w3.org/ns/wsdl-extensions</base:uri>
                <base:uri>http://www.w3.org/ns/wsdl/http</base:uri>
                <base:uri>http://www.w3.org/ns/wsdl/rpc</base:uri>
                <base:uri>http://www.w3.org/ns/wsdl/soap</base:uri>
                <xsl:if test="$wsp-engaged">
                    <base:uri>http://www.w3.org/ns/ws-policy</base:uri>
                </xsl:if>
                <xsl:if test="$wsa-engaged">
                    <base:uri>http://www.w3.org/2007/05/addressing/metadata</base:uri>
                </xsl:if>
                <xsl:if test="$sawsdl-engaged">
                    <base:uri>http://www.w3.org/2007/01/sawsdl#</base:uri>
                </xsl:if>
            </extensions>
            <xsl:if test="$all-interfaces">
                <interfaces>
                    <xsl:apply-templates select="$all-interfaces"/>
                </interfaces>
            </xsl:if>
            <xsl:if test="$all-bindings">
                <bindings>
                    <xsl:apply-templates select="$all-bindings"/>
                </bindings>
            </xsl:if>
            <xsl:if test="$all-services">
                <services>
                    <xsl:apply-templates select="$all-services"/>
                </services>
            </xsl:if>
            <xsl:if test="$all-elements">
                <!-- A little tricky.  To support chameleon includes we can't simply enumerate the
                     $all-elements, as from some of them won't be able to determine the targetNamespace.
                     Instead we'll iterate through xs:schema elements, remembering the namespace as we
                     further iterate through the element declarations.  -->
                <elementDeclarations>
                    <xsl:apply-templates select="wsdl:types/xs:schema | $imported-schema" mode="element"/>
                </elementDeclarations>
            </xsl:if>
            <typeDefinitions>
                <xsl:apply-templates select="wsdl:types/xs:schema | $imported-schema" mode="type"/>
                <xsl:call-template name="built-in-types"/>
            </typeDefinitions>
        </descriptionComponent>
    </xsl:template>
    <!--
        Interface and interface-dependent components
    -->
    <xsl:template match="wsdl:interface">
        <!-- eliminate equivalent interface components - based on name:
            first, see if there are more than one interface with the same QName,
            and if so, suppress any but the first.
        -->
        <xsl:if test="not(count($all-interfaces[@name=current()/@name][../@targetNamespace = current()/../@targetNamespace])>1 and generate-id(.) = generate-id($all-interfaces[@name=current()/@name][../@targetNamespace = current()/../@targetNamespace][1]))">
            <interfaceComponent xml:id="{generate-id(.)}">
                <name>
                    <base:namespaceName>
                        <xsl:value-of select="../@targetNamespace"/>
                    </base:namespaceName>
                    <base:localName>
                        <xsl:value-of select="@name"/>
                    </base:localName>
                </name>
                <xsl:if test="@extends">
                    <extendedInterfaces>
                        <xsl:call-template name="extends">
                            <xsl:with-param name="qnames" select="@extends"/>
                            <xsl:with-param name="namespace-context" select="."/>
                        </xsl:call-template>
                    </extendedInterfaces>
                </xsl:if>
                <xsl:if test="wsdl:fault">
                    <interfaceFaults>
                        <xsl:apply-templates select="wsdl:fault">
                            <xsl:with-param name="targetNamespace" select="../@targetNamespace"/>
                            <xsl:with-param name="parent" select="."/>
                        </xsl:apply-templates>
                    </interfaceFaults>
                </xsl:if>
                <xsl:if test="wsdl:operation">
                    <interfaceOperations>
                        <xsl:apply-templates select="wsdl:operation">
                            <xsl:with-param name="targetNamespace" select="../@targetNamespace"/>
                            <xsl:with-param name="parent" select="."/>
                        </xsl:apply-templates>
                    </interfaceOperations>
                </xsl:if>
	            <xsl:if test="$wsp-engaged">
    	            <wspcm:wspInterfaceExtension>
        	            <xsl:call-template name="ws-policy"/>          
            	    </wspcm:wspInterfaceExtension>      
            	</xsl:if>
                <xsl:if test="$sawsdl-engaged">
                    <sawsdlcm:sawsdlInterfaceExtension>
                        <xsl:call-template name="sawsdl-model-reference"/>          
                    </sawsdlcm:sawsdlInterfaceExtension>      
                </xsl:if>
            </interfaceComponent>
        </xsl:if>
    </xsl:template>
    <xsl:template match="wsdl:interface/wsdl:operation">
        <xsl:param name="targetNamespace"/>
        <xsl:param name="parent"/>
        <interfaceOperationComponent xml:id="{generate-id(.)}">
            <name>
                <base:namespaceName>
                    <xsl:value-of select="$targetNamespace"/>
                </base:namespaceName>
                <base:localName>
                    <xsl:value-of select="@name"/>
                </base:localName>
            </name>
            <messageExchangePattern>
                <xsl:choose>
                    <xsl:when test="@pattern">
                        <xsl:value-of select="@pattern"/>
                    </xsl:when>
                    <xsl:otherwise>http://www.w3.org/ns/wsdl/in-out</xsl:otherwise>
                </xsl:choose>
            </messageExchangePattern>
            <xsl:if test="wsdl:input | wsdl:output">
                <interfaceMessageReferences>
                    <xsl:apply-templates select="wsdl:input | wsdl:output">
                        <xsl:with-param name="parent" select="."/>
                    </xsl:apply-templates>
                </interfaceMessageReferences>
            </xsl:if>
            <xsl:if test="wsdl:infault | wsdl:outfault">
                <interfaceFaultReferences>
                    <xsl:apply-templates select="wsdl:infault | wsdl:outfault">
                        <xsl:with-param name="parent" select="."/>
                    </xsl:apply-templates>
                </interfaceFaultReferences>
            </xsl:if>
            <xsl:choose>
            	<xsl:when test="@style">
	                <style>
	                    <xsl:call-template name="split-uri-list">
	                        <xsl:with-param name="uri-list" select="@style"/>
	                    </xsl:call-template>
	                </style>
	            </xsl:when>
	            <xsl:when test="../@styleDefault">
	                <style>
	                    <xsl:call-template name="split-uri-list">
	                        <xsl:with-param name="uri-list" select="../@styleDefault"/>
	                    </xsl:call-template>
	                </style>
	            </xsl:when>
	        </xsl:choose>
            <base:parent ref="{generate-id($parent)}"/>
            <ext:wsdlInterfaceOperationExtension>
                <ext:safety>
                    <xsl:choose>
                        <xsl:when test="@wsdlx:safe"><xsl:value-of select="@wsdlx:safe"/></xsl:when>
                        <xsl:otherwise>false</xsl:otherwise>
                    </xsl:choose>
                </ext:safety>
            </ext:wsdlInterfaceOperationExtension>
            <xsl:if test="contains(concat(@style,' '), 'http://www.w3.org/ns/wsdl/style/rpc ') or contains(concat(../@styleDefault,' '), 'http://www.w3.org/ns/wsdl/style/rpc ')">
                <rpccm:rpcInterfaceOperationExtension>
                    <rpccm:rpcSignature>
                        <xsl:call-template name="split-rpc">
                            <xsl:with-param name="list" select="@wrpc:signature"/>
                        </xsl:call-template>
                    </rpccm:rpcSignature>
                </rpccm:rpcInterfaceOperationExtension>
            </xsl:if>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspInterfaceOperationExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspInterfaceOperationExtension>      
            </xsl:if>
            <xsl:if test="$sawsdl-engaged">
                <sawsdlcm:sawsdlInterfaceOperationExtension>
                    <xsl:call-template name="sawsdl-model-reference"/>          
                </sawsdlcm:sawsdlInterfaceOperationExtension>      
            </xsl:if>
        </interfaceOperationComponent>
    </xsl:template>
    <!--
        Recursive named template to convert the rpc signature micro-syntax into xml substructure
    -->
    <xsl:template name="split-rpc">
        <xsl:param name="list"/>
        <xsl:if test="$list!=''">
            <xsl:variable name="qname" select="substring-before($list,' ')"/>
            <xsl:variable name="remainder" select="substring-after($list,' ')"/>
            <xsl:variable name="token" select="substring-before(concat($remainder,' '),' ')"/>
            <rpccm:argument>
                <rpccm:name>
                    <base:namespaceName>
                        <xsl:value-of select="namespace::*[local-name()=substring-before($qname,':')]"/>
                    </base:namespaceName>
                    <base:localName>
                        <xsl:value-of select="substring-after($qname,':')"/>
                    </base:localName>
                </rpccm:name>
                <rpccm:direction><xsl:value-of select="$token"/></rpccm:direction>
            </rpccm:argument>
            <xsl:call-template name="split-rpc">
                <xsl:with-param name="list" select="substring-after($remainder,' ')"/>
            </xsl:call-template>
        </xsl:if>    
    </xsl:template>

    <!--
        Recursive named template to convert a space-separated list of styles into xml substructure
    -->
    <xsl:template name="split-uri-list">
        <xsl:param name="uri-list"/>
        <xsl:if test="$uri-list!=''">
            <base:uri><xsl:value-of select="substring-before(concat($uri-list,' '),' ')"/></base:uri>
            <xsl:call-template name="split-uri-list">
                <xsl:with-param name="uri-list" select="substring-after($uri-list,' ')"/>
            </xsl:call-template>
        </xsl:if>    
    </xsl:template>
    <xsl:template match="wsdl:interface/wsdl:fault">
        <xsl:param name="targetNamespace"/>
        <xsl:param name="parent"/>
        <interfaceFaultComponent xml:id="{generate-id(.)}">
            <name>
                <base:namespaceName>
                    <xsl:value-of select="$targetNamespace"/>
                </base:namespaceName>
                <base:localName>
                    <xsl:value-of select="@name"/>
                </base:localName>
            </name>
            <messageContentModel>
                <xsl:choose>
                    <xsl:when test="contains(@element,'#')">
                        <xsl:value-of select="@element"/>
                    </xsl:when>
                    <xsl:when test="@element">#element</xsl:when>
                    <xsl:otherwise>#other</xsl:otherwise>
                </xsl:choose>
            </messageContentModel>
            <xsl:if test="@element">
                <elementDeclaration><xsl:attribute name="ref">
                    <xsl:call-template name="element-ref">
                        <xsl:with-param name="name" select="@element"/>
                        <xsl:with-param name="namespace-context" select="."/>
                    </xsl:call-template>
                </xsl:attribute></elementDeclaration>
            </xsl:if>
            <base:parent ref="{generate-id($parent)}"/>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspInterfaceFaultExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspInterfaceFaultExtension>      
            </xsl:if>
            <xsl:if test="$sawsdl-engaged">
                <sawsdlcm:sawsdlInterfaceFaultExtension>
                    <xsl:call-template name="sawsdl-model-reference"/>          
                </sawsdlcm:sawsdlInterfaceFaultExtension>      
            </xsl:if>
        </interfaceFaultComponent>
    </xsl:template>
    <xsl:template match="wsdl:operation/wsdl:input | wsdl:operation/wsdl:output">
        <xsl:param name="parent"/>
        <interfaceMessageReferenceComponent xml:id="{generate-id(.)}">
            <xsl:variable name="message-label">
                <xsl:choose>
                    <xsl:when test="@messageLabel">
                        <xsl:value-of select="@messageLabel"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="self::wsdl:input">In</xsl:when>
                            <xsl:when test="self::wsdl:output">Out</xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <messageLabel>
                <xsl:value-of select="$message-label"/>
            </messageLabel>
            <direction>
                <xsl:choose>
                    <xsl:when test="self::wsdl:input">in</xsl:when>
                    <xsl:when test="self::wsdl:output">out</xsl:when>
                </xsl:choose>
            </direction>
            <messageContentModel>
                <xsl:choose>
                    <xsl:when test="contains(@element,'#')">
                        <xsl:value-of select="@element"/>
                    </xsl:when>
                    <xsl:when test="@element">#element</xsl:when>
                    <xsl:otherwise>#other</xsl:otherwise>
                </xsl:choose>
            </messageContentModel>
            <xsl:if test="@element and not(contains(@element,'#'))">
                <elementDeclaration><xsl:attribute name="ref">
                    <xsl:call-template name="element-ref">
                        <xsl:with-param name="name" select="@element"/>
                        <xsl:with-param name="namespace-context" select="."/>
                    </xsl:call-template>
                </xsl:attribute></elementDeclaration>
            </xsl:if>
            <base:parent ref="{generate-id($parent)}"/>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspInterfaceMessageReferenceExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspInterfaceMessageReferenceExtension>      
            </xsl:if>
            <xsl:if test="$wsa-engaged">
                <wsacm:wsaInterfaceMessageReferenceExtension>
                    <xsl:call-template name="ws-addressing-action">
                        <xsl:with-param name="message-label" select="$message-label"/>
                    </xsl:call-template>
                </wsacm:wsaInterfaceMessageReferenceExtension>      
            </xsl:if>
        </interfaceMessageReferenceComponent>
    </xsl:template>
    <xsl:template match="wsdl:operation/wsdl:infault | wsdl:operation/wsdl:outfault">
        <xsl:param name="parent"/>
        <interfaceFaultReferenceComponent xml:id="{generate-id(.)}">
            <interfaceFault><xsl:attribute name="ref">
                <xsl:call-template name="fault-ref">
                    <xsl:with-param name="name" select="@ref"/>
                    <xsl:with-param name="namespace-context" select="."/>
                    <xsl:with-param name="interface" select="ancestor::wsdl:interface/@name | ancestor::wsdl:binding/@interface"/>
                </xsl:call-template>
            </xsl:attribute></interfaceFault>
            <xsl:variable name="message-label">
                <xsl:choose>
                    <xsl:when test="@messageLabel">
                        <xsl:value-of select="@messageLabel"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="pattern">
                            <xsl:choose>
                                <xsl:when test="parent::wsdl:operation/@pattern">
                                    <xsl:value-of select="parent::wsdl:operation/@pattern"/>
                                </xsl:when>
                                <xsl:otherwise>http://www.w3.org/ns/wsdl/in-out</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:choose>
                            <!-- No Faults Rule (never applicable in interfaceFaultReferenceComponents)
                                <xsl:when test="$pattern='http://www.w3.org/ns/wsdl/in-only' or
                                $pattern='http://www.w3.org/ns/wsdl/out-only'" />
                            -->
                            <!-- Fault Replaces Message Rule -->
                            <xsl:when test="$pattern='http://www.w3.org/ns/wsdl/in-out' or
                                $pattern='http://www.w3.org/ns/wsdl/in-out'">
                                <xsl:choose>
                                    <xsl:when test="self::wsdl:infault">In</xsl:when>
                                    <xsl:when test="self::wsdl:outfault">Out</xsl:when>
                                </xsl:choose>
                            </xsl:when>
                            <!-- Message Triggers Fault Rule -->
                            <xsl:when test="$pattern='http://www.w3.org/ns/wsdl/robust-in-only' or
                                $pattern='http://www.w3.org/ns/wsdl/in-opt-out' or
                                $pattern='http://www.w3.org/ns/wsdl/robust-out-only' or
                                $pattern='http://www.w3.org/ns/wsdl/out-opt-in' ">
                                <xsl:choose>
                                    <xsl:when test="self::wsdl:infault">Out</xsl:when>
                                    <xsl:when test="self::wsdl:outfault">In</xsl:when>
                                </xsl:choose>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <messageLabel>
                <xsl:value-of select="$message-label"/>
            </messageLabel>
            <direction>
                <xsl:choose>
                    <xsl:when test="self::wsdl:infault">in</xsl:when>
                    <xsl:when test="self::wsdl:outfault">out</xsl:when>
                </xsl:choose>
            </direction>
            <base:parent ref="{generate-id($parent)}"/>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspInterfaceFaultReferenceExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspInterfaceFaultReferenceExtension>      
            </xsl:if>
            <xsl:if test="$wsa-engaged">
                <wsacm:wsaInterfaceFaultReferenceExtension>
                    <xsl:call-template name="ws-addressing-action">
                        <xsl:with-param name="message-label" select="$message-label"/>
                        <xsl:with-param name="fault" select="true()"/>
                    </xsl:call-template>          
                </wsacm:wsaInterfaceFaultReferenceExtension>      
            </xsl:if>
        </interfaceFaultReferenceComponent>
    </xsl:template>
    <!--
        Binding and dependent components
    -->
    <xsl:template match="wsdl:binding">
        <bindingComponent xml:id="{generate-id(.)}">
            <name>
                <base:namespaceName>
                    <xsl:value-of select="../@targetNamespace"/>
                </base:namespaceName>
                <base:localName>
                    <xsl:value-of select="@name"/>
                </base:localName>
            </name>
            <xsl:if test="@interface">
                <interface><xsl:attribute name="ref">
                    <xsl:call-template name="interface-ref">
                        <xsl:with-param name="name" select="@interface"/>
                        <xsl:with-param name="namespace-context" select="."/>
                    </xsl:call-template>
                </xsl:attribute></interface>
            </xsl:if>
            <type>
                <xsl:value-of select="@type"/>
            </type>
            <xsl:if test="wsdl:fault">
                <bindingFaults>
                    <xsl:apply-templates select="wsdl:fault">
                        <xsl:with-param name="parent" select="."/>
                    </xsl:apply-templates>
                </bindingFaults>
            </xsl:if>
            <xsl:if test="wsdl:operation">
                <bindingOperations>
                    <xsl:apply-templates select="wsdl:operation">
                        <xsl:with-param name="parent" select="."/>
                    </xsl:apply-templates>
                </bindingOperations>
            </xsl:if>
            <xsl:if test="@type='http://www.w3.org/ns/wsdl/http'">
                <httpcm:httpBindingExtension>
                    <httpcm:httpCookies>
                        <xsl:choose>
                            <xsl:when test="@whttp:cookies"><xsl:value-of select="@whttp:cookies"/></xsl:when>
                            <xsl:otherwise>false</xsl:otherwise>
                        </xsl:choose>
                    </httpcm:httpCookies>
                    <xsl:if test="@whttp:methodDefault">
                        <httpcm:httpMethodDefault>
                            <xsl:value-of select="@whttp:methodDefault"/>
                        </httpcm:httpMethodDefault>
                    </xsl:if>
                    <httpcm:httpQueryParameterSeparatorDefault>
                        <xsl:choose>
                            <xsl:when test="@whttp:queryParameterSeparatorDefault">
                                <xsl:value-of select="@whttp:queryParameterSeparatorDefault"/>
                            </xsl:when>
                            <xsl:otherwise>&amp;</xsl:otherwise>
                        </xsl:choose>
                    </httpcm:httpQueryParameterSeparatorDefault>
                    <xsl:if test="@whttp:contentEncodingDefault">
                        <httpcm:httpContentEncodingDefault>
                            <xsl:value-of select="@whttp:contentEncodingDefault"/>
                        </httpcm:httpContentEncodingDefault>
                    </xsl:if>
                </httpcm:httpBindingExtension>
            </xsl:if>
            <xsl:if test="@type='http://www.w3.org/ns/wsdl/soap'">
                <soapcm:soapBindingExtension>
                    <xsl:if test="(@wsoap:protocol='http://www.w3.org/2003/05/soap/bindings/HTTP/') or
                        (@wsoap:version='1.1' and @wsoap:protocol='http://www.w3.org/2006/01/soap11/bindings/HTTP/')">
                        <httpcm:httpCookies>
                            <xsl:choose>
                                <xsl:when test="@whttp:cookies"><xsl:value-of select="@whttp:cookies"/></xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </httpcm:httpCookies>
                        <xsl:if test="@whttp:contentEncodingDefault">
                            <httpcm:httpContentEncodingDefault>
                                <xsl:value-of select="@whttp:contentEncodingDefault"/>
                            </httpcm:httpContentEncodingDefault>
                        </xsl:if>
                        <httpcm:httpQueryParameterSeparatorDefault>
                            <xsl:choose>
                                <xsl:when test="@whttp:queryParameterSeparatorDefault">
                                    <xsl:value-of select="@whttp:queryParameterSeparatorDefault"/>
                                </xsl:when>
                                <xsl:otherwise>&amp;</xsl:otherwise>
                            </xsl:choose>
                        </httpcm:httpQueryParameterSeparatorDefault>
                    </xsl:if>
                    <xsl:if test="@wsoap:mepDefault">
                        <soapcm:soapMepDefault>
                            <xsl:value-of select="@wsoap:mepDefault"/>
                        </soapcm:soapMepDefault>
                    </xsl:if>
                    <xsl:call-template name="soap-module"/>
                    <soapcm:soapUnderlyingProtocol>
                        <xsl:value-of select="@wsoap:protocol"/>
                    </soapcm:soapUnderlyingProtocol>
                    <soapcm:soapVersion>
                        <xsl:choose>
                            <xsl:when test="@wsoap:version"><xsl:value-of select="@wsoap:version"/></xsl:when>
                            <xsl:otherwise>1.2</xsl:otherwise>
                        </xsl:choose>
                    </soapcm:soapVersion>
                </soapcm:soapBindingExtension>
            </xsl:if>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspBindingExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspBindingExtension>      
            </xsl:if>
        </bindingComponent>
    </xsl:template>
    <xsl:template match="wsdl:binding/wsdl:fault">
        <xsl:param name="parent"/>
        <bindingFaultComponent xml:id="{generate-id(.)}">
            <interfaceFault><xsl:attribute name="ref">
                <xsl:call-template name="fault-ref">
                    <xsl:with-param name="name" select="@ref"/>
                    <xsl:with-param name="namespace-context" select="."/>
                    <xsl:with-param name="interface" select="ancestor::wsdl:binding/@interface"/>
                </xsl:call-template>
            </xsl:attribute></interfaceFault>
            <base:parent ref="{generate-id($parent)}"/>
            <xsl:if test="parent::wsdl:binding/@type='http://www.w3.org/ns/wsdl/http'">
                <httpcm:httpBindingFaultExtension>
                    <httpcm:httpErrorStatusCode>
                        <xsl:if test="@whttp:code">
                            <httpcm:code><xsl:value-of select="@whttp:code"/></httpcm:code>
                        </xsl:if>
                    </httpcm:httpErrorStatusCode>
                    <xsl:call-template name="http-headers"/>
                    <xsl:if test="@whttp:contentEncoding">
                        <httpcm:httpContentEncoding>
                            <xsl:value-of select="@whttp:contentEncoding"/>
                        </httpcm:httpContentEncoding>
                    </xsl:if>
                </httpcm:httpBindingFaultExtension>
            </xsl:if>
            <xsl:if test="parent::wsdl:binding/@type='http://www.w3.org/ns/wsdl/soap'">
                <soapcm:soapBindingFaultExtension>
                    <xsl:if test="parent::wsdl:binding[(@wsoap:protocol='http://www.w3.org/2003/05/soap/bindings/HTTP/') or
                        (@wsoap:version='1.1' and @wsoap:protocol='http://www.w3.org/2006/01/soap11/bindings/HTTP/')]">
                        <xsl:call-template name="http-headers"/>
                        <xsl:if test="@whttp:contentEncoding">
                            <httpcm:httpContentEncoding>
                                <xsl:value-of select="@whttp:contentEncoding"/>
                            </httpcm:httpContentEncoding>
                        </xsl:if>
                    </xsl:if>
                    <soapcm:soapFaultCode>
                        <xsl:if test="@wsoap:code and @wsoap:code!='#any'">
                            <soapcm:code>
                                <base:namespaceName>
                                    <xsl:value-of select="namespace::*[local-name()=substring-before(current()/@wsoap:code,':')]"/>
                                </base:namespaceName>
                                <base:localName>
                                    <xsl:value-of select="substring-after(@wsoap:code,':')"/>
                                </base:localName>
                            </soapcm:code>
                        </xsl:if>
                    </soapcm:soapFaultCode>
                    <soapcm:soapFaultSubcodes>
                        <xsl:if test="@wsoap:subcodes and @wsoap:subcodes!='#any'">
                            <soapcm:subcodes>
                                <xsl:call-template name="soap-subcodes">
                                    <xsl:with-param name="list" select="@wsoap:subcodes"/>
                                </xsl:call-template>
                            </soapcm:subcodes>
                        </xsl:if>                    
                    </soapcm:soapFaultSubcodes>
                    <xsl:call-template name="soap-module"/>
                    <xsl:call-template name="soap-headers"/>
                </soapcm:soapBindingFaultExtension>
            </xsl:if>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspBindingFaultExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspBindingFaultExtension>      
            </xsl:if>
        </bindingFaultComponent>
    </xsl:template>
    <xsl:template match="wsdl:binding/wsdl:operation">
        <xsl:param name="parent"/>
        <bindingOperationComponent xml:id="{generate-id(.)}">
            <interfaceOperation><xsl:attribute name="ref">
                <xsl:call-template name="operation-ref">
                    <xsl:with-param name="name" select="@ref"/>
                    <xsl:with-param name="namespace-context" select="."/>
                    <xsl:with-param name="interface" select="ancestor::wsdl:binding/@interface"/>
                </xsl:call-template>
            </xsl:attribute></interfaceOperation>
            <xsl:if test="wsdl:input | wsdl:output">
                <bindingMessageReferences>
                    <xsl:apply-templates select="wsdl:input | wsdl:output">
                        <xsl:with-param name="parent" select="."/>
                    </xsl:apply-templates>
                </bindingMessageReferences>
            </xsl:if>
            <xsl:if test="wsdl:infault | wsdl:outfault">
                <bindingFaultReferences>
                    <xsl:apply-templates select="wsdl:infault | wsdl:outfault">
                        <xsl:with-param name="parent" select="."/>
                    </xsl:apply-templates>
                </bindingFaultReferences>
            </xsl:if>
            <base:parent ref="{generate-id($parent)}"/>
            <xsl:if test="ancestor::wsdl:binding/@type='http://www.w3.org/ns/wsdl/http'">
                <xsl:variable name="effective-http-method">
                    <xsl:choose>
                        <xsl:when test="@whttp:method"><xsl:value-of select="@whttp:method"/></xsl:when>
                        <xsl:when test="parent::wsdl:binding/@whttp:methodDefault"><xsl:value-of select="parent::wsdl:binding/@whttp:methodDefault"/></xsl:when>
                        <xsl:when test="$all-operations[@name=substring-after(current()/@ref,':')][ancestor::wsdl:description/@targetNamespace=current()/namespace::*[local-name()=substring-before(current()/@ref,':')]]/@wsdlx:safe='true'">GET</xsl:when>
                        <xsl:otherwise>POST</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <httpcm:httpBindingOperationExtension>
                    <httpcm:httpFaultSerialization>
                        <xsl:choose>
                            <xsl:when test="@whttp:faultSerialization">
                                <xsl:value-of select="@whttp:faultSerialization"/>
                            </xsl:when>
                            <xsl:otherwise>application/xml</xsl:otherwise>
                        </xsl:choose>
                    </httpcm:httpFaultSerialization>
                    <httpcm:httpInputSerialization>
                        <xsl:choose>
                            <xsl:when test="@whttp:inputSerialization">
                                <xsl:value-of select="@whttp:inputSerialization"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:choose>
                                    <xsl:when test="$effective-http-method='GET'">application/x-www-form-urlencoded</xsl:when>
                                    <xsl:when test="$effective-http-method='POST'">application/xml</xsl:when>
                                    <xsl:when test="$effective-http-method='PUT'">application/xml</xsl:when>
                                    <xsl:when test="$effective-http-method='DELETE'">application/x-www-form-urlencoded</xsl:when>
                                    <xsl:otherwise>application/xml</xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </httpcm:httpInputSerialization>
                    <xsl:if test="@whttp:location">
                        <httpcm:httpLocation>
                            <xsl:value-of select="@whttp:location"/>
                        </httpcm:httpLocation>
                    </xsl:if>
                    <httpcm:httpLocationIgnoreUncited>
                        <xsl:choose>
                            <xsl:when test="@whttp:ignoreUncited">
                                <xsl:value-of select="@whttp:ignoreUncited"/>
                            </xsl:when>
                            <xsl:otherwise>false</xsl:otherwise>
                        </xsl:choose>    
                    </httpcm:httpLocationIgnoreUncited>
                    <xsl:if test="@whttp:method">
                        <httpcm:httpMethod>
                            <xsl:value-of select="@whttp:method"/>
                        </httpcm:httpMethod>
                    </xsl:if>
                    <httpcm:httpOutputSerialization>
                        <xsl:choose>
                            <xsl:when test="@whttp:outputSerialization">
                                <xsl:value-of select="@whttp:outputSerialization"/>
                            </xsl:when>
                            <xsl:otherwise>application/xml</xsl:otherwise>
                        </xsl:choose>
                    </httpcm:httpOutputSerialization>
                    <xsl:if test="@whttp:queryParameterSeparator">
                        <httpcm:httpQueryParameterSeparator>
                            <xsl:value-of select="@whttp:queryParameterSeparator"/>
                        </httpcm:httpQueryParameterSeparator>
                    </xsl:if>
                    <xsl:if test="@whttp:contentEncodingDefault">
                        <httpcm:httpContentEncodingDefault>
                            <xsl:value-of select="@whttp:contentEncodingDefault"/>
                        </httpcm:httpContentEncodingDefault>
                    </xsl:if>
                </httpcm:httpBindingOperationExtension>
            </xsl:if>
            <xsl:if test="parent::wsdl:binding/@type='http://www.w3.org/ns/wsdl/soap'">
                <soapcm:soapBindingOperationExtension>
                    <xsl:if test="parent::wsdl:binding[(@wsoap:protocol='http://www.w3.org/2003/05/soap/bindings/HTTP/') or
                        (@wsoap:version='1.1' and @wsoap:protocol='http://www.w3.org/2006/01/soap11/bindings/HTTP/')]">
                        <xsl:if test="@whttp:location">
                            <httpcm:httpLocation>
                                <xsl:value-of select="@whttp:location"/>
                            </httpcm:httpLocation>
                        </xsl:if>
                        <xsl:if test="@whttp:contentEncodingDefault">
                            <httpcm:httpContentEncodingDefault>
                                <xsl:value-of select="@whttp:contentEncodingDefault"/>
                            </httpcm:httpContentEncodingDefault>
                        </xsl:if>
                        <xsl:if test="@whttp:queryParameterSeparator">
                            <httpcm:httpQueryParameterSeparator>
                                <xsl:value-of select="@whttp:queryParameterSeparator"/>
                            </httpcm:httpQueryParameterSeparator>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="@wsoap:action">
                        <soapcm:soapAction>
                            <xsl:value-of select="@wsoap:action"/>
                        </soapcm:soapAction>
                    </xsl:if>
                    <xsl:if test="@wsoap:mep">
                        <soapcm:soapMep>
                            <xsl:value-of select="@wsoap:mep"/>
                        </soapcm:soapMep>
                    </xsl:if>
                    <xsl:call-template name="soap-module"/>
                </soapcm:soapBindingOperationExtension>
            </xsl:if>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspBindingOperationExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspBindingOperationExtension>      
            </xsl:if>
        </bindingOperationComponent>
    </xsl:template>
    <xsl:template match="wsdl:binding/wsdl:operation/wsdl:input | wsdl:binding/wsdl:operation/wsdl:output">
        <xsl:param name="parent"/>
        <bindingMessageReferenceComponent xml:id="{generate-id(.)}">
            <interfaceMessageReference><xsl:attribute name="ref">
                <xsl:call-template name="message-ref">
                    <xsl:with-param name="label" >
                    	<xsl:choose>
		                    <xsl:when test="@messageLabel">
		                        <xsl:value-of select="@messageLabel"/>
		                    </xsl:when>
		                    <xsl:otherwise>
		                        <xsl:choose>
		                            <xsl:when test="self::wsdl:input">In</xsl:when>
		                            <xsl:when test="self::wsdl:output">Out</xsl:when>
		                        </xsl:choose>
		                    </xsl:otherwise>
		                </xsl:choose>
			        </xsl:with-param>
			        <xsl:with-param name="operation" select="../@ref"/>
                    <xsl:with-param name="namespace-context" select="."/>
                </xsl:call-template>
            </xsl:attribute></interfaceMessageReference>
            <base:parent ref="{generate-id($parent)}"/>
            <xsl:if test="ancestor::wsdl:binding/@type='http://www.w3.org/ns/wsdl/http'">
                <httpcm:httpBindingMessageReferenceExtension>
                    <xsl:call-template name="http-headers"/>
                    <xsl:if test="@whttp:contentEncoding">
                        <httpcm:httpContentEncoding>
                            <xsl:value-of select="@whttp:contentEncoding"/>
                        </httpcm:httpContentEncoding>
                    </xsl:if>
                </httpcm:httpBindingMessageReferenceExtension>
            </xsl:if>
            <xsl:if test="ancestor::wsdl:binding/@type='http://www.w3.org/ns/wsdl/soap'">
                <soapcm:soapBindingMessageReferenceExtension>
                    <xsl:if test="ancestor::wsdl:binding[(@wsoap:protocol='http://www.w3.org/2003/05/soap/bindings/HTTP/') or
                        (@wsoap:version='1.1' and @wsoap:protocol='http://www.w3.org/2006/01/soap11/bindings/HTTP/')]">
                        <xsl:call-template name="http-headers"/>
                        <xsl:if test="@whttp:contentEncoding">
                            <httpcm:httpContentEncoding>
                                <xsl:value-of select="@whttp:contentEncoding"/>
                            </httpcm:httpContentEncoding>
                        </xsl:if>
                    </xsl:if>
                    <xsl:call-template name="soap-module"/>
                    <xsl:call-template name="soap-headers"/>
                </soapcm:soapBindingMessageReferenceExtension>
            </xsl:if>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspBindingMessageReferenceExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspBindingMessageReferenceExtension>      
            </xsl:if>
        </bindingMessageReferenceComponent>
    </xsl:template>
    <xsl:template match="wsdl:binding/wsdl:operation/wsdl:infault | wsdl:binding/wsdl:operation/wsdl:outfault">
        <xsl:param name="parent"/>
        <bindingFaultReferenceComponent xml:id="{generate-id(.)}">
            <interfaceFaultReference><xsl:attribute name="ref">
                <xsl:call-template name="fault-reference-ref">
                    <xsl:with-param name="ref" select="@ref"/>
                    <xsl:with-param name="operation" select="../@ref"/>
                    <xsl:with-param name="namespace-context" select="."/>
                </xsl:call-template>
            </xsl:attribute></interfaceFaultReference>
            <base:parent ref="{generate-id($parent)}"/>
            <xsl:if test="ancestor::wsdl:binding/@type='http://www.w3.org/ns/wsdl/soap'">
                <soapcm:soapBindingFaultReferenceExtension>
                    <xsl:call-template name="soap-module"/>
                </soapcm:soapBindingFaultReferenceExtension>
            </xsl:if>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspBindingFaultReferenceExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspBindingFaultReferenceExtension>      
            </xsl:if>
        </bindingFaultReferenceComponent>
    </xsl:template>
    <!--
        Service and endpoint components
    -->
    <xsl:template match="wsdl:service">
        <serviceComponent xml:id="{generate-id(.)}">
            <name>
                <base:namespaceName>
                    <xsl:value-of select="../@targetNamespace"/>
                </base:namespaceName>
                <base:localName>
                    <xsl:value-of select="@name"/>
                </base:localName>
            </name>
            <interface><xsl:attribute name="ref">
                <xsl:call-template name="interface-ref">
                    <xsl:with-param name="name" select="@interface"/>
                    <xsl:with-param name="namespace-context" select="."/>
                </xsl:call-template>
            </xsl:attribute></interface>
            <endpoints>
                <xsl:apply-templates select="wsdl:endpoint">
                    <xsl:with-param name="parent" select="."/>
                </xsl:apply-templates>
            </endpoints>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspServiceExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspServiceExtension>      
            </xsl:if>
        </serviceComponent>
    </xsl:template>
    <xsl:template match="wsdl:endpoint">
        <xsl:param name="parent"/>
        <endpointComponent xml:id="{generate-id(.)}">
            <name>
                <xsl:value-of select="@name"/>
            </name>
            <binding><xsl:attribute name="ref">
                <xsl:call-template name="binding-ref">
                    <xsl:with-param name="name" select="@binding"/>
                    <xsl:with-param name="namespace-context" select="."/>
                </xsl:call-template>
            </xsl:attribute></binding>
            <xsl:if test="@address">
                <address><xsl:value-of select="@address"/></address>
            </xsl:if>
            <base:parent ref="{generate-id($parent)}"/>
            <xsl:variable name="this-binding" select="@binding"/>
            <xsl:variable name="this-namespace" select="namespace::*[local-name()=substring-before($this-binding,':')]"/>
            <xsl:variable name="binding" select="$all-bindings[@name=substring-after($this-binding,':')][ancestor::wsdl:description/@targetNamespace=$this-namespace]"/>
            <xsl:if test="$binding[@type='http://www.w3.org/ns/wsdl/http']">
                <httpcm:httpEndpointExtension>
                    <xsl:if test="@whttp:authenticationRealm">
                        <httpcm:httpAuthenticationRealm>
                            <xsl:value-of select="@whttp:authenticationRealm"/>
                        </httpcm:httpAuthenticationRealm>
                    </xsl:if>
                    <xsl:if test="@whttp:authenticationScheme">
                        <httpcm:httpAuthenticationScheme>
                            <xsl:value-of select="@whttp:authenticationScheme"/>
                        </httpcm:httpAuthenticationScheme>
                    </xsl:if>
                </httpcm:httpEndpointExtension>
        	</xsl:if>
            <xsl:if test="$binding[@type='http://www.w3.org/ns/wsdl/soap' and (
                    (@wsoap:protocol='http://www.w3.org/2003/05/soap/bindings/HTTP/') or
                    (@wsoap:version='1.1' and @wsoap:protocol='http://www.w3.org/2006/01/soap11/bindings/HTTP/')
                    )]">
                <soapcm:soapEndpointExtension>
                    <xsl:if test="@whttp:authenticationRealm">
                        <httpcm:httpAuthenticationRealm>
                            <xsl:value-of select="@whttp:authenticationRealm"/>
                        </httpcm:httpAuthenticationRealm>
                    </xsl:if>
                    <xsl:if test="@whttp:authenticationScheme">
                        <httpcm:httpAuthenticationScheme>
                            <xsl:value-of select="@whttp:authenticationScheme"/>
                        </httpcm:httpAuthenticationScheme>
                    </xsl:if>
                </soapcm:soapEndpointExtension>
        	</xsl:if>
            <xsl:if test="$wsp-engaged">
                <wspcm:wspEndpointExtension>
                    <xsl:call-template name="ws-policy"/>          
                </wspcm:wspEndpointExtension>      
            </xsl:if>
            <xsl:if test="$wsa-engaged">
                <wsacm:wsaEndpointExtension>
                    <xsl:call-template name="ws-addressing-epr"/>                    
                </wsacm:wsaEndpointExtension>
            </xsl:if>
        </endpointComponent>
    </xsl:template>
    <!-- 
        Templates to generate IDs of linked components
    -->
    <xsl:template name="element-ref">
        <xsl:param name="name"/>
        <xsl:param name="namespace-context"/>
        <xsl:variable name="local-name">
            <xsl:choose>
                <xsl:when test="contains($name,':')"><xsl:value-of select="substring-after($name,':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefix" select="substring-before($name,':')"/>
        <xsl:variable name="namespace-name" select="$namespace-context/namespace::*[local-name()=$prefix]"/>
        <xsl:for-each select="$all-elements[@name=$local-name][not(../@targetNamespace) or ../@targetNamespace=$namespace-name]">
            <xsl:value-of select="generate-id(.)"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="type-ref">
        <xsl:param name="name"/>
        <xsl:param name="namespace-context"/>
        <xsl:variable name="local-name">
            <xsl:choose>
                <xsl:when test="contains($name,':')"><xsl:value-of select="substring-after($name,':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefix" select="substring-before($name,':')"/>
        <xsl:variable name="namespace-name" select="$namespace-context/namespace::*[local-name()=$prefix]"/>
        <xsl:choose>
            <xsl:when test="$namespace-name = 'http://www.w3.org/2001/XMLSchema'">xs-<xsl:value-of select="$local-name"/></xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$all-types[@name=$local-name][not(../@targetNamespace) or ../@targetNamespace=$namespace-name]">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="fault-ref">
        <xsl:param name="name"/>
        <xsl:param name="namespace-context"/>
        <xsl:param name="interface"/>
        <xsl:variable name="interface-local-name">
            <xsl:choose>
                <xsl:when test="contains($interface, ':')"><xsl:value-of select="substring-after($interface, ':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$interface"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="local-name">
            <xsl:choose>
                <xsl:when test="contains($name,':')"><xsl:value-of select="substring-after($name,':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefix" select="substring-before($name,':')"/>
        <xsl:variable name="namespace-name" select="$namespace-context/namespace::*[local-name()=$prefix]"/>
        <xsl:for-each select="$all-faults[@name=$local-name][ancestor::wsdl:description/@targetNamespace=$namespace-name][ancestor::wsdl:interface/@name=normalize-space($interface-local-name)]">
            <xsl:value-of select="generate-id(.)"/>
        </xsl:for-each>
        <xsl:for-each select="$all-interfaces[@name=$interface-local-name][@extends]">
            <xsl:call-template name="fault-ref">
                <xsl:with-param name="name" select="$name"/>
                <xsl:with-param name="namespace-context" select="$namespace-context"/>
                <xsl:with-param name="interface" select="@extends"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="fault-reference-ref">
        <xsl:param name="ref"/>
        <xsl:param name="operation"/>
        <xsl:param name="namespace-context"/>
        <xsl:variable name="local-name">
            <xsl:choose>
                <xsl:when test="contains($operation,':')"><xsl:value-of select="substring-after($operation,':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$operation"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefix" select="substring-before($operation,':')"/>
        <xsl:variable name="namespace-name" select="$namespace-context/namespace::*[local-name()=$prefix]"/>
        <xsl:for-each select="$all-operations[@name=$local-name][ancestor::wsdl:description/@targetNamespace=$namespace-name]">
            <xsl:value-of select="generate-id(wsdl:infault[local-name($namespace-context)='infault'][@ref=$ref] | wsdl:outfault[local-name($namespace-context)='outfault'][@ref=$ref])"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="interface-ref">
        <xsl:param name="name"/>
        <xsl:param name="namespace-context"/>
        <xsl:variable name="local-name">
            <xsl:choose>
                <xsl:when test="contains($name,':')"><xsl:value-of select="substring-after($name,':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefix" select="substring-before($name,':')"/>
        <xsl:variable name="namespace-name" select="$namespace-context/namespace::*[local-name()=$prefix]"/>
        <xsl:for-each select="$all-interfaces[@name=$local-name][ancestor::wsdl:description/@targetNamespace=$namespace-name]">
            <xsl:value-of select="generate-id(.)"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="operation-ref">
        <xsl:param name="name"/>
        <xsl:param name="namespace-context"/>
        <xsl:param name="interface"/>
        <xsl:variable name="interface-local-name">
            <xsl:choose>
                <xsl:when test="contains($interface, ':')"><xsl:value-of select="substring-after($interface, ':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$interface"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="local-name">
            <xsl:choose>
                <xsl:when test="contains($name,':')"><xsl:value-of select="substring-after($name,':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefix" select="substring-before($name,':')"/>
        <xsl:variable name="namespace-name" select="$namespace-context/namespace::*[local-name()=$prefix]"/>
		<xsl:variable name="interfaces-extended-by-this-one">
        	<xsl:call-template name="interface-list">
        		<xsl:with-param name="interface" select="$all-interfaces[@name=$interface-local-name]"/>
        	</xsl:call-template>
        </xsl:variable>
        <xsl:for-each select="$all-operations[@name=$local-name]
	        [ancestor::wsdl:description/@targetNamespace=$namespace-name]
			[contains($interfaces-extended-by-this-one, concat('[',ancestor::wsdl:interface/@name,']'))]">
            <xsl:value-of select="generate-id(.)"/>
        </xsl:for-each>
    </xsl:template>

	<xsl:template name="interface-list">
		<xsl:param name="interface"/>
		<xsl:text>[</xsl:text>
		<xsl:value-of select="$interface/@name"/>
    	<xsl:text>]</xsl:text>
		<xsl:if test="$interface/@extends">
	    	<xsl:call-template name="extended-interface-list">
	    		<xsl:with-param name="interface-names" select="$interface/@extends"/>
	    	</xsl:call-template>
	    </xsl:if>
	</xsl:template>

	<xsl:template name="extended-interface-list">
		<xsl:param name="interface-names"/>
        <xsl:variable name="qnamesplit" select="concat(normalize-space($interface-names),' ')"/>
        <xsl:variable name="firstqname" select="substring-before($qnamesplit,' ')"/>
        <xsl:variable name="remainder" select="substring-after($qnamesplit,' ')"/>
        <xsl:variable name="interface-local-name">
            <xsl:choose>
                <xsl:when test="contains($firstqname, ':')"><xsl:value-of select="substring-after($firstqname, ':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$firstqname"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="interface-list">
            <xsl:with-param name="interface" select="$all-interfaces[@name=$interface-local-name]"/>
        </xsl:call-template>
		<xsl:if test="$remainder != ''">
	    	<xsl:call-template name="extended-interface-list">
	    		<xsl:with-param name="interface-names" select="$remainder"/>
	    	</xsl:call-template>
	    </xsl:if>
	</xsl:template>

    <xsl:template name="message-ref">
        <xsl:param name="label"/>
        <xsl:param name="operation"/>
        <xsl:param name="namespace-context"/>
        <xsl:variable name="local-name">
            <xsl:choose>
                <xsl:when test="contains($operation,':')"><xsl:value-of select="substring-after($operation,':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$operation"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefix" select="substring-before($operation,':')"/>
        <xsl:variable name="namespace-name" select="$namespace-context/namespace::*[local-name()=$prefix]"/>
        <xsl:for-each select="$all-operations[@name=$local-name][ancestor::wsdl:description/@targetNamespace=$namespace-name]">
            <xsl:value-of select="generate-id(
            	wsdl:input[@messageLabel and @messageLabel=$label] |
            	wsdl:output[@messageLabel and @messageLabel=$label] |
            	wsdl:input[$label='In'] |
            	wsdl:output[$label='Out']
            )"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="binding-ref">
        <xsl:param name="name"/>
        <xsl:param name="namespace-context"/>
        <xsl:variable name="local-name">
            <xsl:choose>
                <xsl:when test="contains($name,':')"><xsl:value-of select="substring-after($name,':')"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$name"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="prefix" select="substring-before($name,':')"/>
        <xsl:variable name="namespace-name" select="$namespace-context/namespace::*[local-name()=$prefix]"/>
        <xsl:for-each select="$all-bindings[@name=$local-name][ancestor::wsdl:description/@targetNamespace=$namespace-name]">
            <xsl:value-of select="generate-id(.)"/>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="extends">
        <xsl:param name="qnames" />
        <xsl:param name="namespace-context" />
        <xsl:if test="$qnames != ''">
            <xsl:variable name="qnamesplit" select="concat(normalize-space($qnames),' ')"/>
            <interface><xsl:attribute name="ref">
                <xsl:call-template name="interface-ref">
                    <xsl:with-param name="name" select="substring-before($qnamesplit,' ')"/>
                    <xsl:with-param name="namespace-context" select="$namespace-context"/>
                </xsl:call-template>
            </xsl:attribute></interface>
            <xsl:call-template name="extends">
                <xsl:with-param name="qnames" select="substring-after($qnamesplit,' ')"/>
                <xsl:with-param name="namespace-context" select="$namespace-context"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!--
        Schema-related components
    -->
    <xsl:template match="xs:schema" mode="element">
        <xsl:variable name="targetNamespace" select="@targetNamespace"/>
        <xsl:variable name="elements" select="xs:element | document(xs:include/@schemaLocation)/xs:schema/xs:element"/>
        <xsl:for-each select="$elements">
            <elementDeclarationComponent xml:id="{generate-id(.)}">
                <name>
                    <base:namespaceName>
                        <xsl:value-of select="$targetNamespace"/>
                    </base:namespaceName>
                    <base:localName>
                        <xsl:value-of select="@name"/>
                    </base:localName>
                </name>
                <system>http://www.w3.org/2001/XMLSchema</system>
                <xsl:if test="$sawsdl-engaged">
                    <sawsdlcm:sawsdlElementDeclarationExtension>
                        <xsl:variable name="type-local-name">
                        	<xsl:choose>
                        		<xsl:when test="contains(@type, ':')">
                        			<xsl:value-of select="substring-after(@type, ':')"/>
                        		</xsl:when>
                        		<xsl:otherwise>
                        			<xsl:value-of select="@type"/>
                        		</xsl:otherwise>
                        	</xsl:choose>
                        </xsl:variable>
				    	<xsl:variable name="type-prefix" select="substring-before(@type, ':')"/>
				    	<xsl:variable name="type-namespace-name" select="namespace::*[local-name()=$type-prefix]"/>
				    	<xsl:variable name="referenced-type" select="$all-types[@name=$type-local-name][../@targetNamespace=$type-namespace-name]"/>
				        <xsl:if test="@sawsdl:modelReference or $referenced-type/@sawsdl:modelReference">
				            <sawsdlcm:modelReference>
				                <xsl:call-template name="split-uri-list">
				                    <xsl:with-param name="uri-list" select="normalize-space(concat(@sawsdl:modelReference, ' ', $referenced-type/@sawsdl:modelReference))"/>
				                </xsl:call-template>
				            </sawsdlcm:modelReference>
				        </xsl:if>
				        <xsl:if test="@sawsdl:liftingSchemaMapping or $referenced-type/@sawsdl:liftingSchemaMapping">
				            <sawsdlcm:liftingSchemaMapping>
				                <xsl:call-template name="split-uri-list">
				                    <xsl:with-param name="uri-list" select="normalize-space(concat(@sawsdl:liftingSchemaMapping, ' ', $referenced-type/@sawsdl:liftingSchemaMapping))"/>
				                </xsl:call-template>
				            </sawsdlcm:liftingSchemaMapping>
				        </xsl:if>
				        <xsl:if test="@sawsdl:loweringSchemaMapping or $referenced-type/@sawsdl:loweringSchemaMapping">
				            <sawsdlcm:loweringSchemaMapping>
				                <xsl:call-template name="split-uri-list">
				                    <xsl:with-param name="uri-list" select="normalize-space(concat(@sawsdl:loweringSchemaMapping, ' ', $referenced-type/@sawsdl:loweringSchemaMapping))"/>
				                </xsl:call-template>
				            </sawsdlcm:loweringSchemaMapping>
				        </xsl:if>
                    </sawsdlcm:sawsdlElementDeclarationExtension>      
                </xsl:if>
            </elementDeclarationComponent>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="xs:schema" mode="type">
        <xsl:variable name="targetNamespace" select="@targetNamespace"/>
        <xsl:variable name="types" select="xs:simpleType | xs:complexType | document(xs:include/@schemaLocation)/xs:schema/xs:simpleType | document(xs:include/@schemaLocation)/xs:schema/xs:complexType"/>
        <xsl:for-each select="$types">
            <typeDefinitionComponent xml:id="{generate-id(.)}">
                <name>
                    <base:namespaceName>
                        <xsl:value-of select="$targetNamespace"/>
                    </base:namespaceName>
                    <base:localName>
                        <xsl:value-of select="@name"/>
                    </base:localName>
                </name>
                <system>http://www.w3.org/2001/XMLSchema</system>
                <xsl:if test="$sawsdl-engaged">
                    <sawsdlcm:sawsdlTypeDefinitionExtension>
                        <xsl:call-template name="sawsdl-model-reference"/>          
                        <xsl:call-template name="sawsdl-lifting-schema-mapping"/>
                        <xsl:call-template name="sawsdl-lowering-schema-mapping"/>
                    </sawsdlcm:sawsdlTypeDefinitionExtension>      
                </xsl:if>
            </typeDefinitionComponent>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="built-in-types">
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">anyURI</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">base64Binary</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">boolean</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">byte</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">date</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">dateTime</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">decimal</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">double</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">duration</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">ENTITIES</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">ENTITY</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">float</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">gDay</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">gMonth</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">gMonthDay</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">gYear</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">gYearMonth</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">hexBinary</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">ID</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">IDREF</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">IDREFS</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">int</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">integer</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">language</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">long</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">Name</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">NCName</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">negativeInteger</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">NMTOKEN</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">NMTOKENS</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">nonNegativeInteger</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">nonPositiveInteger</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">normalizedString</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">NOTATION</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">positiveInteger</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">QName</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">short</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">string</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">time</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">token</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">unsignedByte</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">unsignedInt</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">unsignedLong</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="built-in-simple-type">
            <xsl:with-param name="type">unsignedShort</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="built-in-simple-type">
        <xsl:param name="type"/>
        <typeDefinitionComponent xml:id="xs-{$type}">
            <name>
                <base:namespaceName>http://www.w3.org/2001/XMLSchema</base:namespaceName>
                <base:localName><xsl:value-of select="$type"/></base:localName>
            </name>
            <system>http://www.w3.org/2001/XMLSchema</system>
            <xsl:if test="$sawsdl-engaged">
                <sawsdlcm:sawsdlTypeDefinitionExtension/>      
            </xsl:if>
        </typeDefinitionComponent>
    </xsl:template>
    <xsl:template name="soap-module">
        <xsl:if test="wsoap:module">
            <soapcm:soapModules>
                <xsl:for-each select="wsoap:module">
                    <soapcm:soapModuleComponent xml:id="{generate-id(.)}">
                        <soapcm:ref><xsl:value-of select="@ref"/></soapcm:ref>
                        <soapcm:required>
                            <xsl:choose>
                                <xsl:when test="@required"><xsl:value-of select="@required"/></xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </soapcm:required>
                        <base:parent ref="{generate-id(..)}"/>
                    </soapcm:soapModuleComponent>
                </xsl:for-each>
            </soapcm:soapModules>
        </xsl:if>
    </xsl:template>
    <xsl:template name="soap-headers">
        <xsl:if test="wsoap:header">
            <soapcm:soapHeaders>
                <xsl:for-each select="wsoap:header">
                    <soapcm:soapHeaderBlockComponent xml:id="{generate-id(.)}">
                        <soapcm:elementDeclaration><xsl:attribute name="ref">
		                    <xsl:call-template name="element-ref">
		                        <xsl:with-param name="name" select="@element"/>
		                        <xsl:with-param name="namespace-context" select="."/>
		                    </xsl:call-template>
		                </xsl:attribute></soapcm:elementDeclaration>
                        <soapcm:mustUnderstand>
                            <xsl:choose>
                                <xsl:when test="@mustUnderstand"><xsl:value-of select="@mustUnderstand"/></xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </soapcm:mustUnderstand>
                        <soapcm:required>
                            <xsl:choose>
                                <xsl:when test="@required"><xsl:value-of select="@required"/></xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </soapcm:required>
                        <base:parent ref="{generate-id(..)}"/>
                    </soapcm:soapHeaderBlockComponent>
                </xsl:for-each>
            </soapcm:soapHeaders>
        </xsl:if>
    </xsl:template>
    <xsl:template name="http-headers">
        <xsl:if test="whttp:header">
            <httpcm:httpHeaders>
                <xsl:for-each select="whttp:header">
                    <httpcm:httpHeaderComponent xml:id="{generate-id(.)}">
                        <httpcm:name>
                            <xsl:value-of select="@name"/>
                        </httpcm:name>
                        <httpcm:typeDefinition><xsl:attribute name="ref"><xsl:call-template name="type-ref">
                            <xsl:with-param name="name" select="@type"/>
                            <xsl:with-param name="namespace-context" select="."/>
                        </xsl:call-template></xsl:attribute>
                        </httpcm:typeDefinition>
                        <httpcm:required>
                            <xsl:choose>
                                <xsl:when test="@required">
                                    <xsl:value-of select="@required"/>
                                </xsl:when>
                                <xsl:otherwise>false</xsl:otherwise>
                            </xsl:choose>
                        </httpcm:required>
                        <base:parent ref="{generate-id(..)}"/>
                    </httpcm:httpHeaderComponent>
                </xsl:for-each>
            </httpcm:httpHeaders>
        </xsl:if>
    </xsl:template>
    <xsl:template name="soap-subcodes">
        <xsl:param name="list"/>
        <xsl:if test="$list!=''">
            <soapcm:code>
                <base:namespaceName>
                    <xsl:value-of select="namespace::*[local-name()=substring-before($list,':')]"/>
                </base:namespaceName>
                <base:localName>
                    <xsl:value-of select="substring-after(substring-before(concat($list,' '),' '),':')"/>
                </base:localName>
            </soapcm:code>        
            <xsl:call-template name="soap-subcodes">
                <xsl:with-param name="list" select="substring-after($list,' ')"/>
            </xsl:call-template>
        </xsl:if>    
    </xsl:template>

    <!-- WS-Policy 1.5 extension support -->
    <xsl:template name="ws-policy">
        <xsl:if test="wsp:Policy">
            <wsacm:policy>
                <!-- Note, this doesn't do a merge as required! -->
                <xsl:copy-of select="wsp:Policy"/>
            </wsacm:policy>
        </xsl:if>        
    </xsl:template>

    <!-- WS-Addressing 1.0 extension support -->
    <xsl:template name="ws-addressing-action">
        <xsl:param name="fault" select="false()"/>
        <xsl:param name="message-label"/>
        <xsl:variable name="targetNamespace" select="ancestor::wsdl:description/@targetNamespace"/>
        <xsl:variable name="delimiter">
            <xsl:choose>
                <xsl:when test="starts-with($targetNamespace,'urn:')">:</xsl:when>
                <xsl:otherwise>/</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <wsacm:action>
            <xsl:choose>
                <xsl:when test="@wsam:Action">
                    <xsl:value-of select="@wsam:Action"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="direction-token">
                        <xsl:choose>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/in-only'"/>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/robust-in-only'"/>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/out-only'"/>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/robust-out-only'"/>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/in-out' and $message-label='In'">Request</xsl:when>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/out-in' and $message-label='Out'">Solicit</xsl:when>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/out-opt-in' and $message-label='Out'">Solicit</xsl:when>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/in-out' and $message-label='Out'">Response</xsl:when>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/in-opt-out' and $message-label='Out'">Response</xsl:when>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/out-in' and $message-label='In'">Response</xsl:when>
                            <xsl:when test="ancestor::wsdl:operation/@pattern='http://www.w3.org/ns/wsdl/out-opt-in' and $message-label='In'">Response</xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$message-label"/>
                            </xsl:otherwise>
                        </xsl:choose>                        
                    </xsl:variable>
                    <xsl:value-of select="$targetNamespace"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="ancestor::wsdl:interface/@name"/>
                    <xsl:value-of select="$delimiter"/>
                    <xsl:value-of select="ancestor::wsdl:operation/@name"/>
                    <xsl:value-of select="$direction-token"/> 
                    <xsl:if test="$fault">
                        <xsl:value-of select="$delimiter"/>
                        <xsl:choose>
                            <xsl:when test="contains(@ref,':')">
                                <xsl:value-of select="substring-after(@ref,':')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@ref"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </wsacm:action>
    </xsl:template>
    <xsl:template name="ws-addressing-epr">
        <xsl:if test="wsa:EndpointReference">
            <wsacm:endpointReference>
                <xsl:copy-of select="wsa:EndpointReference"/>
            </wsacm:endpointReference>
        </xsl:if>
    </xsl:template>

    <!-- SAWSDL extension support -->
    <xsl:template name="sawsdl-model-reference">
        <xsl:if test="@sawsdl:modelReference">
            <sawsdlcm:modelReference>
                <xsl:call-template name="split-uri-list">
                    <xsl:with-param name="uri-list" select="@sawsdl:modelReference"/>
                </xsl:call-template>
            </sawsdlcm:modelReference>
        </xsl:if>
    </xsl:template>
    <xsl:template name="sawsdl-lifting-schema-mapping">
        <xsl:if test="@sawsdl:liftingSchemaMapping">
            <sawsdlcm:liftingSchemaMapping>
                <xsl:call-template name="split-uri-list">
                    <xsl:with-param name="uri-list" select="@sawsdl:liftingSchemaMapping"/>
                </xsl:call-template>
            </sawsdlcm:liftingSchemaMapping>
        </xsl:if>
    </xsl:template>
    <xsl:template name="sawsdl-lowering-schema-mapping">
        <xsl:if test="@sawsdl:loweringSchemaMapping">
            <sawsdlcm:loweringSchemaMapping>
                <xsl:call-template name="split-uri-list">
                    <xsl:with-param name="uri-list" select="@sawsdl:loweringSchemaMapping"/>
                </xsl:call-template>
            </sawsdlcm:loweringSchemaMapping>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
