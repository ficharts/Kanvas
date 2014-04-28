package 
{
	import com.kvs.ui.Panel;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.ui.label.LabelUI;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import framework.utils.AIRRemoteUpdater;
	
	[Event(name="complete", type="flash.events.Event")]
	
	public final class AIRUpdater extends Sprite
	{
		public function AIRUpdater()
		{
			super();
		}
		
		public function update(value:String, type:String = "update"):void
		{
			_url = value;
			_type = type;
			visible = false;
			updater = new AIRRemoteUpdater;
			updater.addEventListener("versionCheck", cltComplete);
			updater.addEventListener("ioError"     , cltComplete);
			updater.addEventListener("runtimeError", cltComplete);
			updater.update(new URLRequest(value), _type);
		}
		private function cltComplete(e:Event):void
		{
			updater.removeEventListener("versionCheck", cltComplete);
			updater.removeEventListener("ioError"     , cltComplete);
			updater.removeEventListener("runtimeError", cltComplete);
			if (e.type=="ioError"||e.type=="runtimeError") {
				updater = null;
				dispatchEvent(new Event(Event.COMPLETE));
			} else {
				
				if (updater.updatable) {
					if (_type == "update") {
						updater.addEventListener("progress"    , cltProgress);
						updater.addEventListener("update"      , cltFinished);
						updater.addEventListener("runtimeError", cltFinished);
						if (stage)
						{
							visible = true;
							panel = new Panel;
							panel.reTitle("");
							panel.w = 200;
							panel.h = 100;
							panel.graphics.beginFill(0xDDDDDD);
							panel.graphics.drawRect(0, 0, panel.w, panel.h);
							panel.graphics.endFill();
							panel.addChild(progress = new Sprite);
							progress.x = 25;
							progress.y = 50;
							render();
						}
					} else {
						if (stage)
						{
							visible = true;
							panel = new Panel;
							panel.addChild(okBtn = new LabelBtn);
							panel.addChild(noBtn = new LabelBtn);
							panel.addChild(label = new LabelUI);
							panel.reTitle("");
							panel.w = 200;
							panel.h = 100;
							panel.graphics.beginFill(0xDDDDDD);
							panel.graphics.drawRect(0, 0, panel.w, panel.h);
							panel.graphics.endFill();
							okBtn.text = "确定";
							noBtn.text = "取消";
							okBtn.w = 50;
							okBtn.h = 24;
							noBtn.w = 50;
							noBtn.h = 24;
							okBtn.x = 30;
							noBtn.x = 110;
							okBtn.y = 50;
							noBtn.y = 50;
							label.text = "检测到有新版本，是否更新？";
							label.x = 10;
							label.y = 10;
							okBtn.addEventListener(MouseEvent.CLICK, okClick);
							noBtn.addEventListener(MouseEvent.CLICK, noClick);
							addChild(panel);
							render();
						}
					}
				} else dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function render():void
		{
			if (visible && stage)
			{
				graphics.clear();
				graphics.beginFill(0x000000, .8);
				graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				if (panel) 
				{
					panel.x = stage.stageWidth  * .5 - panel.w * .5;
					panel.y = stage.stageHeight * .5 - panel.h * .5;
				}
			}
		}
		
		private function okClick(e:MouseEvent):void
		{
			updater.addEventListener("progress"    , cltProgress);
			updater.addEventListener("update"      , cltFinished);
			updater.addEventListener("runtimeError", cltFinished);
			updater.update(new URLRequest(_url), "force");
			panel.removeChild(okBtn);
			panel.removeChild(noBtn);
			panel.addChild(progress = new Sprite);
			progress.x = 25;
			progress.y = 50;
		}
		
		private function noClick(e:MouseEvent):void
		{
			destroy();
		}
		
		private function destroy():void
		{
			visible = false;
			removeChild(panel);
			okBtn.removeEventListener(MouseEvent.CLICK, okClick);
			noBtn.removeEventListener(MouseEvent.CLICK, noClick);
			panel = null;
			okBtn = null;
			noBtn = null;
			label = null;
			progress = null;
		}
		
		private function cltProgress(e:ProgressEvent):void
		{
			if (progress)
			{
				progress.graphics.clear();
				progress.graphics.lineStyle(3, 0x333333);
				progress.graphics.moveTo(0, 0);
				progress.graphics.lineTo(150, 0);
				progress.graphics.lineStyle(1, 0xEEEEEE);
				progress.graphics.moveTo(0, 0);
				progress.graphics.lineTo(150 * e.bytesLoaded / e.bytesTotal, 0);
			}
		}
		private function cltFinished(e:Event):void
		{
			updater.removeEventListener("progress"    , cltProgress);
			updater.removeEventListener("update"      , cltFinished);
			updater.removeEventListener("runtimeError", cltFinished);
			updater = null;
		}
		
		private var updater:AIRRemoteUpdater;
		
		private var panel:Panel;
		
		private var okBtn:LabelBtn;
		
		private var noBtn:LabelBtn;
		
		private var label:LabelUI;
		
		private var progress:Sprite;
		
		private var _type:String = "update";
		
		private var _url:String;
	}
}