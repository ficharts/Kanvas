package landray.kp.maps.main.comman
{
	import com.kvs.ui.toolTips.ToolTipHolder;
	import com.kvs.ui.toolTips.ToolTipsEvent;
	import com.kvs.ui.toolTips.ToolTipsManager;
	import com.kvs.utils.RexUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import landray.kp.core.KPConfig;
	import landray.kp.core.KPEmbeds;
	import landray.kp.core.kp_internal;
	import landray.kp.maps.main.elements.Element;
	import landray.kp.utils.ExternalUtil;
	import landray.kp.view.Viewer;

	public final class ElementToolTip
	{
		public function ElementToolTip()
		{
			initialize();
		}
		
		private function initialize():void
		{
			config = KPConfig.instance;
			embeds = KPEmbeds.instance;
			
			viewer = config.kp_internal::viewer;
			
			viewer.addEventListener(MouseEvent.MOUSE_OVER   , showHandler);
			viewer.addEventListener(MouseEvent.MOUSE_OUT    , hideHandler);
			viewer.addEventListener(Event.REMOVED_FROM_STAGE, hideHandler);
			
			tipsVO      = new ToolTipHolder;
			tipsManager = new ToolTipsManager(viewer);
			
			tipsManager.setStyleXML(embeds.styleTips);
		}
		
		public function showToolTip(msg:String, w:Number = 0):void
		{
			if (element)
			{
				element.tips = msg;
				element.tipWidth = w;
				setMultiLine(w);
				showTips();
			}
		}
		
		private function showHandler(e:MouseEvent):void
		{
			if (e.target is Element)
			{
				element = Element(e.target);
				tipsVO.metaData = element;
				
				if (element.related)
				{
					if (element.tips)
					{
						setMultiLine(element.tipWidth);
						showTips();
					}
					else
						ExternalUtil.kanvasLinkOvered(element.vo.id);
				}
			}
		}
		
		private function hideHandler(e:Event):void
		{
			hideTips();
		}
		
		private function setMultiLine(w:Number):void
		{
			if (w > 0)
			{
				tipsManager.getStyle().layout = "wrap";
				tipsManager.maxWidth = w;
			}
		}
		
		private function showTips():void
		{
			if (enabled &&　! showing && element && ! RexUtil.ifTextNull(element.tips))
			{
				element.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.SHOW_TOOL_TIPS, tipsVO));
				showing = true;
			}
		}
		
		private function hideTips():void
		{
			if (showing)
			{
				element.dispatchEvent(new ToolTipsEvent(ToolTipsEvent.HIDE_TOOL_TIPS));
				showing = false;
			}
		}
		
		/**
		 */		
		public function set enabled(value:Boolean):void
		{
			if (enabled != value)
			{
				__enabled = value;
				if (! enabled)
					hideTips();
			}
			
		}
		/**
		 */		
		public function get enabled():Boolean
		{
			return __enabled;
		}
		
		/**
		 */		
		private var __enabled:Boolean = true;
		
		
		private var viewer:Viewer;
		
		private var element:Element;
		
		private var tipsVO:ToolTipHolder;
		
		private var showing:Boolean;
		
		private var tipsManager:ToolTipsManager;
		
		private var config:KPConfig;
		
		private var embeds:KPEmbeds;
	}
}