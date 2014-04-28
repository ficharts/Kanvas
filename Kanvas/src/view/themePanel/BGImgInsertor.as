package view.themePanel
{
	import com.kvs.ui.button.IconBtn;
	import com.kvs.ui.button.LabelBtn;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.graphic.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import landray.kp.ui.Loading;
	
	/**
	 * 背景图片上传选择组件
	 */	
	public class BGImgInsertor extends Sprite
	{
		public function BGImgInsertor(host:ThemePanel)
		{
			super();
			
			this.host = host;
			
			addChild(imgCanvas);
			
			imgBtn = new LabelBtn;
			imgBtn.w = w - 8;
			imgBtn.h = h -  8;
			imgBtn.x = imgBtn.y = 4;
			imgBtn.text = '上传3D背景图';
			imgBtn.labelStyleXML = noImgLabelStyle;
			addChild(imgBtn);
			
			addChild(shapeDashed = new Bitmap(new frame));
			shapeDashed.width = w;
			shapeDashed.height = h;
			shapeDashed.x = 0;
			shapeDashed.y = 0;
			
			
			deleteBtn = new IconBtn;
			deleteBtn.tips = '删除背景图';
			deleteBtn.iconW = deleteBtn.iconH = 18;
			
			del_up;
			del_over;
			del_down;
			deleteBtn.setIcons('del_up', 'del_over', 'del_down');
			
			addChild(deleteBtn);
			deleteBtn.x = w;
			
			updateState();
			
			deleteBtn.addEventListener(MouseEvent.CLICK, deleteClick);
			
			this.addEventListener(MouseEvent.CLICK, insertImgHandler);
			host.kvs.kvsCore.addEventListener(KVSEvent.UPDATE_BG_IMG, updateBGImg);
		}
		
		/**
		 * 
		 */		
		private function updateState():void
		{
			deleteBtn.visible = hasImage;
			
			if (hasImage)
			{
				imgBtn.text = '替换背景图';
				imgBtn.updateLabelStyle(hasImgLabelStyle);
				imgBtn.updateBgStyle(hasImgStyleXML);
			}
			else
			{
				imgBtn.text = '上传3D背景图';
				imgBtn.updateLabelStyle(noImgLabelStyle);
				imgBtn.updateBgStyle(noImgStyleXML);
			}
			imgBtn.render();
		}
		
		/**
		 * 有数据时，绘制图片；无数据时，仅清空已有图片
		 */		
		private function updateBGImg(evt:KVSEvent):void
		{
			imgCanvas.graphics.clear();
			
			hideLoading();
			
			hasImage = Boolean(evt.bgIMG);
			
			if (hasImage)
			{
				var cw:Number = w - 8;
				var ch:Number = h - 8;
				var bw:Number = evt.bgIMG.width;
				var bh:Number = evt.bgIMG.height;
				var scale:Number = ((cw / ch) > (bw / bh)) ? ch / bh : cw / bw;
				var nw:Number = bw * scale;
				var nh:Number = bh * scale;
				
				BitmapUtil.drawBitmapDataToShape(evt.bgIMG, imgCanvas, nw, nh, 4 + (cw - nw) * .5, 4 + (ch - nh) * .5);
			}
			
			updateState();
		}
		
		/**
		 */		
		private var imgCanvas:Shape = new Shape;
		
		/**
		 */		
		private function insertImgHandler(evt:MouseEvent):void
		{
			host.kvs.kvsCore.insertBgImg(imgLocalHandler);
		}
		
		private function imgLocalHandler():void
		{
			showLoading();
			
			hasImage = true;
			updateState();
		}
		
		private function deleteClick(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			hideLoading();
			host.kvs.kvsCore.deleteBgImg();
			hasImage = false;
			
			updateState();
		}
		
		private function showLoading():void
		{
			if (loading == null)
			{
				loading = new Loading;
				loading.x = w * .5;
				loading.y = h * .5;
				addChildAt(loading, 0);
			}
		}
		
		/**
		 */		
		private function hideLoading():void
		{
			if (loading)
			{
				if (contains(loading))
					removeChild(loading);
				
				loading.stop();
				loading = null;
			}
		}
		
		/**
		 */		
		private var host:ThemePanel;
		
		private var loading:Loading;
		
		private var imgBtn     :LabelBtn;
		private var shapeDashed:Bitmap;
		private var deleteBtn  :IconBtn;
		
		private var hasImage:Boolean;
		private var w:Number = 110;
		private var h:Number = 80;
		
		/**
		 */		
		private const noImgStyleXML:XML = <states>
												<normal radius='0'>
													<fill color='#DDDDDD' alpha='0'/>
												</normal>
												<hover>
													<fill color='#dddddd' alpha='0.8' angle="90"/>
												</hover>
												<down>
													<fill color='#bbbbbb' alpha='0.8' angle="90"/>
												</down>
											</states>;
			
			
			
		private const hasImgStyleXML:XML = <states>
												<normal radius='0'>
													<fill color='#555555' alpha='0.2'/>
												</normal>
												<hover>
													<fill color='#555555' alpha='0.6' angle="90"/>
												</hover>
												<down>
													<fill color='#555555' alpha='0.8' angle="90"/>
												</down>
											</states>
			
		private const noImgLabelStyle:XML = <label vAlign="center">
								                <format color='555555' font='微软雅黑' size='12' letterSpacing="3"/>
								            </label>
			
		private const hasImgLabelStyle:XML = <label vAlign="center">
								                <format color='ffffff' font='微软雅黑' size='12' letterSpacing="3"/>
								            </label>
			
		
	}
}