package view.ui
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.kvs.ui.label.LabelUI;
	
	import flash.display.Stage;
	
	/**
	 * 全局信息提示
	 */	
	public final class Bubble
	{
		public static function init(stage:Stage = null):Bubble
		{
			if (instance == null)
				instance = new Bubble(stage);
			return instance;
		}
		
		/**
		 */		
		private static var instance:Bubble;
		
		/**
		 */		
		public static function show(text:String):void
		{
			if (instance) instance.show(text);
		}
		
		/**
		 */		
		public function Bubble($stage:Stage)
		{
			if (instance == null)
			{
				super();
				initialize($stage);
			}
			else
			{
				throw new Error("SingleTon", 2001);
			}
		}
		
		/**
		 */		
		private function initialize($stage:Stage):void
		{
			stage = $stage;
			
			labelBtn = new LabelUI;
			labelBtn.styleXML = lbStyle;
			labelBtn.alpha = 0;
			labelBtn.mouseEnabled = labelBtn.mouseChildren = false;
		}
		
		/**
		 * 
		 */		
		private function show(text:String, time:Number = 1):void
		{
			if (stage)
			{
				if (labelBtn.text != text)
				{
					labelBtn.text = text;
					stage.addChild(labelBtn);
					labelBtn.render();
					
					labelBtn.x = .5 * (stage.stageWidth - labelBtn.width);
					labelBtn.y = stage.stageHeight;
					
					if (isShowing)
					{
						labelBtn.alpha = 1;
						labelBtn.y = stage.stageHeight - labelBtn.height - 10;
					}
					else
					{
						isShowing = true;
						
						TweenMax.to(labelBtn, .5, {alpha: 1, y: stage.stageHeight - labelBtn.height - 10, ease: Back.easeOut});
						TweenMax.to(labelBtn, .5, {alpha: 0, y: stage.stageHeight, delay:time + 1, onComplete: hideComplete, ease: Back.easeIn});
					}
					
				}
			}
		}
		
		/**
		 */		
		private function hideComplete():void
		{
			stage.removeChild(labelBtn);
			labelBtn.text = "";
			isShowing = false;
		}
		
		/**
		 */		
		private var isShowing:Boolean = false;
		
		/**
		 */		
		private const lbStyle:XML = <label hPadding='12' vPadding='8' radius='30' vMargin='10' hMargin='20'>
										<border thikness='1' alpha='0' color='555555' pixelHinting='true'/>
										<fill color='e96565' alpha='0.9'/>
										<format font='华文细黑' size='15' color='ffffff'/>
										<text value='${tips}'>
											<effects>
												<shadow color='0' alpha='0.3' distance='1' blur='1' angle='90'/>
											</effects>
										</text>
									</label>;
		
	
		/**
		 */		
		private var stage:Stage;
		
		/**
		 */		
		private var labelBtn:LabelUI;
	}
}