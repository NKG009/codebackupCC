<!--Access the app directly eg:
https://sourcebreaker1.lightning.force.com/c/SbLanding.app?inputParam=xxxxxxxx
-->

<aura:application implements="lightning:hasPageReference" extends="ltng:outApp"  access="GLOBAL">
    
    <aura:dependency resource="c:SbLandingCmp"/>
    <aura:dependency resource="markup://force:*" type="EVENT" />

</aura:application>