package landray.kp.core
{
	import com.kvs.ui.toolTips.ToolTipsManager;
	import com.kvs.utils.Map;
	import com.kvs.utils.XMLConfigKit.XMLVOLib;
	
	import flash.display.DisplayObjectContainer;
	
	import landray.kp.components.Selector;
	import landray.kp.components.ToolBarSlide;
	import landray.kp.components.ToolBarZoom;
	import landray.kp.manager.ManagerPage;
	import landray.kp.maps.main.comman.ElementToolTip;
	import landray.kp.mediator.MediatorViewer;
	import landray.kp.view.*;
	
	import model.vo.BgVO;
	
	import view.interact.PreviewClicker;
	import view.interact.zoomMove.ZoomMoveControl;
	import view.ui.Debugger;
	
	public final class KPConfig
	{
		public  static const instance:KPConfig = new KPConfig;
		private static var   created :Boolean;
		
		
		public function KPConfig()
		{
			if(!created) 
			{
				created = true;
				super();
				initialize();
			} 
			else 
			{
				throw new Error("Single Ton!");
			}
		}
		
		private function initialize():void
		{
			kp_internal::graphs = new Vector.<Graph>;
			kp_internal::themes = new Map;
			kp_internal::lib    = new XMLVOLib;
			kp_internal::bgVO   = new BgVO;
		}
		
		public var id:String;
		
		/**
		 * 自动布局时，画布保持原比例，不缩放 
		 */		
		public var originalScale:Boolean;
		
		kp_internal var container  :DisplayObjectContainer;
		kp_internal var viewer     :Viewer;
		kp_internal var mediator   :MediatorViewer;
		kp_internal var controller :ZoomMoveControl;
		kp_internal var previewClicker :PreviewClicker;
		
		kp_internal var selector   :Selector;
		kp_internal var toolBarZoom:ToolBarZoom;
		kp_internal var toolBarSlid:ToolBarSlide;
		kp_internal var toolTip    :ElementToolTip;
		kp_internal var pageManager:ManagerPage;
		kp_internal var debugger   :Debugger;
		
		kp_internal var tipsManager:ToolTipsManager;
		kp_internal var graphs     :Vector.<Graph>;
		kp_internal var themes     :Map;
		kp_internal var lib        :XMLVOLib;
		kp_internal var theme      :String;
		kp_internal var bgVO       :BgVO;
		kp_internal var domain     :String;
	}
}