package view.templatePanel
{
	import com.kvs.ui.Panel;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.utils.RexUtil;
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
			
			w = 1024;
			h = 576;
			
			addChild(templatesContainer = new Sprite);
			
			scrollProxy = new TemplatesScrollProxy(this);
			
			boxLayout = new BoxLayout;
			boxLayout.setLoc(15, barHeight - 20);
			boxLayout.setItemSizeAndFullWidth(1000, 210, 160);
			boxLayout.setHoriHeightAndGap(160, 210, 0);
			boxLayout.gap = 30;
			boxLayout.ready();
			
			submit = new LabelBtn;
			submit.w = 120;
			submit.h = 25;
			submit.x = 1024 - 130 - 130;
			submit.y = 576 - 35;
			submit.text = "使用选定模板";
			submit.bgStyleXML = submitBgStyle;
			submit.labelStyleXML = submitStyle;
			submit.addEventListener(MouseEvent.CLICK, submitClickHandler);
			addChild(submit);
			
			cancel = new LabelBtn;
			cancel.w = 120;
			cancel.h = 25;
			cancel.x = 1024 - 130;
			cancel.y = 576 - 35;
			cancel.text = "使用空白模板";
			cancel.bgStyleXML = submitBgStyle;
			cancel.labelStyleXML = submitStyle;
			cancel.addEventListener(MouseEvent.CLICK, cancelClickHandler);
			addChild(cancel);
			
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
			
			graphics.clear();
			graphics.beginFill(0xEEEEEE, .5);
			graphics.drawRect(-x, -y, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
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
				if (RexUtil.ifHasText(xml.@icon))
					item.setIcons(xml.@icon, xml.@icon, xml.@icon);
				templatesContainer.addChild(item);
				boxLayout.layout(item);
				item.addEventListener(MouseEvent.DOUBLE_CLICK, templateDoubleClickHandler);
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
			if (curItem)
			{
				core.api.openTemplate(curItem.id);
				cancelClickHandler(null);
			}
		}
		
		private function cancelClickHandler(e:MouseEvent):void
		{
			close(stage.stageWidth * .5, stage.stageHeight * .5 + 10);
		}
		
		private function templateDoubleClickHandler(e:MouseEvent):void
		{
			core.api.openTemplate(curItem.id);
			cancelClickHandler(null);
		}
		
		private function templateClickedHandler(e:MouseEvent):void
		{
			if (e.target is TemplateItem)
			{
				var item:TemplateItem = TemplateItem(e.target);
				if (curItem) 
				{
					if (item != curItem)
					{
						item.selected = true;
						curItem.selected = false;
						curItem = item;
					}
					else
					{
						curItem.selected = false;
						curItem = null;
					}
				}
				else
				{
					curItem = item;
					item.selected = true;
				}
				//core.api.openTemplate(e.target.id);
				//submitClickHandler(null);
			}
		}
		
		private var curItem:TemplateItem;
		
		private var core:Kanvas;
		
		private var submit:LabelBtn;
		
		private var cancel:LabelBtn;
		
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
			</templates>;
	}
}