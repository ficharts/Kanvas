package view.templatePanel
{
	import com.kvs.ui.Panel;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.utils.layout.BoxLayout;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import view.templatePanel.TemplatesScrollProxy;
	
	public final class TemplatePanel extends Panel
	{
		public function TemplatePanel($core:Kanvas)
		{
			super();
			core = $core;
		}
		
		override protected function init():void
		{
			super.init();
			
			title = "模板";
			
			w = 600;
			h = 400;
			
			addChild(templatesContainer = new Sprite);
			
			scrollProxy = new TemplatesScrollProxy(this);
			
			boxLayout = new BoxLayout;
			boxLayout.setLoc(30, barHeight + 5);
			boxLayout.setItemSizeAndFullWidth(540, 90, 70);
			boxLayout.setHoriHeightAndGap(70, 90, 0);
			boxLayout.ready();
			
			submit = new LabelBtn;
			submit.w = 50;
			submit.h = 25;
			submit.x = 530;
			submit.y = 365;
			submit.text = "取消";
			submit.bgStyleXML = submitBgStyle;
			submit.labelStyleXML = submitStyle;
			submit.addEventListener(MouseEvent.CLICK, submitClickHandler);
			addChild(submit);
			
			render();
			
			imitTemplates();
		}
		
		override public function updateLayout():void
		{
			super.updateLayout();
			
			if (scrollProxy)
			{
				scrollProxy.updateMask();
				scrollProxy.update();
			}
			
			x = .5 * (stage.stageWidth - w);
			y = .5 * (stage.stageHeight - h);
		}
		
		public function get fullSize():Number
		{
			return (boxLayout) ? boxLayout.getRectHeight() : 0;
		}
		
		private function imitTemplates():void
		{
			for each (var xml:XML in templateData.children())
			{
				var item:TemplateItem = new TemplateItem;
				item.id = xml.@id;
				item.tips = xml.@name;
				item.setIcons(xml.@icon, xml.@icon, xml.@icon);
				templatesContainer.addChild(item);
				boxLayout.layout(item);
			}
			
			if (scrollProxy)
			{
				scrollProxy.updateMask();
				scrollProxy.update();
			}
			
			templatesContainer.addEventListener(MouseEvent.CLICK, templateClickedHandler);
		}
		
		private function submitClickHandler(e:MouseEvent):void
		{
			close(stage.stageWidth * .5, stage.stageHeight * .5 + 10);
		}
		
		private function templateClickedHandler(e:MouseEvent):void
		{
			if (e.target is TemplateItem)
			{
				core.api.openTemplate(e.target.id);
				submitClickHandler(null);
			}
		}
		
		private var core:Kanvas;
		
		private var submit:LabelBtn;
		
		private var scrollProxy:TemplatesScrollProxy;
		
		private var boxLayout:BoxLayout;
		
		internal var templatesContainer:Sprite;
		
		private static const submitBgStyle:XML = 
			<states>
				<normal>
					<fill color='#CCCCCC' alpha='1'/>
				</normal>
				<hover>
					<fill color='#FFFFFF' alpha='0.9' angle="90"/>
				</hover>
				<down>
					<fill color='#AAAAAA' alpha='0.3' angle="90"/>
				</down>
			</states>;
		
		private static const submitStyle:XML = 
			<label vAlign="center">
				<format color='555555' font='微软雅黑' size='12' letterSpacing="3"/>
			</label>;
		
		private static const templateData:XML = 
			<templates>
				<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
<template id='1' icon='' name='模板1'/>
			</templates>;
	}
}