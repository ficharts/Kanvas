package view.templatePanel
{
	import com.kvs.ui.Panel;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.utils.layout.BoxLayout;
	
	import flash.display.Sprite;
	
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
			x = .5 * (stage.stageWidth - w);
			y = .5 * (stage.stageHeight - h);
			titleStyleXML = titleStyle;
			
			addChild(templatesContainer = new Sprite);
			templatesContainer.x = 5;
			templatesContainer.y = barHeight + 5;
			
			scrollProxy = new TemplatesScrollProxy(this);
			
			boxLayout = new BoxLayout;
			boxLayout.setLoc(0, 0);
			boxLayout.gap = 0;
			
			submit = new LabelBtn;
			submit.w = 50;
			submit.h = 25;
			submit.x = 540;
			submit.y = 365;
			submit.text = "确定";
			submit.labelStyleXML = submitStyle;
			addChild(submit);
			
			imitTemplates();
		}
		
		private function imitTemplates():void
		{
			var item:TemplateItem = createEmptyTemplate();
			
			boxLayout.layout(item);
		}
		
		private function createEmptyTemplate():TemplateItem
		{
			var item:TemplateItem = new TemplateItem;
			item.tips = "空白模板";
			return item;
		}
		
		private var core:Kanvas;
		
		private var submit:LabelBtn;
		
		private var scrollProxy:TemplatesScrollProxy;
		
		private var boxLayout:BoxLayout;
		
		internal var templatesContainer:Sprite;
		
		private static const titleStyle:XML = 
			<label radius='0' vPadding='20' hPadding='20'>
				<format color='#555555' font='微软雅黑' size='16'/>
			</label>;
		
		private static const submitStyle:XML = 
			<label vAlign="center">
				<format color='555555' font='微软雅黑' size='12' letterSpacing="3"/>
			</label>;
		
		private static const templateData:XML = 
			<templates>
				<template/>
			</templates>;
	}
}