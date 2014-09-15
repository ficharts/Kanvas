package view.element.imgElement
{
	import com.kvs.utils.RexUtil;
	
	import flash.utils.ByteArray;
	
	import landray.kp.ui.Loading;
	
	import model.vo.ElementVO;
	import model.vo.ImgVO;
	
	import util.img.ImageManager;
	
	import view.element.ElementBase;
	import view.element.ElementEvent;
	import view.element.ISource;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 */	
	public class ImgElementBase extends ElementBase implements IAutoGroupElement, ISource
	{
		public function ImgElementBase(vo:ElementVO)
		{
			super(vo);
			
			vo.xml = <image/>;
			autoGroupChangable = false;
			
			// 图片加载状态初始化
			loadingState = new LoadingState(this);
			normalState = new NormalState(this);
			currLoadState = loadingState;
		}
		
		/**
		 */		
		public function get dataID():String
		{
			return imgVO.imgID.toString();
		}
		
		
		
		
		
		
		
		
		
		//------------------------------------------
		//
		//
		// 图片有两种特殊状态： 加载状态和正常状态
		//
		// 默认为加载状态，此时正在加载/上传图片
		//
		//
		//------------------------------------------
		
		
		/**
		 */		
		public function toNomalState():void
		{
			graphics.clear();
			
			currLoadState = normalState;
			removeLoading();
			
			if (imgVO.viewData)
			{
				imgVO.width  = imgVO.viewData.width;
				imgVO.height = imgVO.viewData.height;
			}
			
			initIMG(imgVO.viewData);
			
			currLoadState.render();
			
			dispatchEvent(new ElementEvent(ElementEvent.IMAGE_TO_RENDER));
		}
		
		/**
		 */		
		public function imgLoaded(fileBytes:ByteArray, viewData:Object):void
		{
			imgVO.viewData = viewData;
			
			//客户端一次开启多个图片会导致文件打开卡住，所以需要滞后处理图片的渲染, 防止刚刚打开文件的卡顿
			ImageManager.pushForRender(this);
		}
		
		/**
		 */		
		protected function initIMG(bmd:Object):void
		{
			
		}
		
		/**
		 */		
		public function showIMG():void
		{
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			rendered = true;
			super.render();
			
			// 图片插入时
			if (imgVO.viewData)
				currLoadState.render();
			else if (imgVO.url != "null" && RexUtil.ifHasText(imgVO.url))// 再次编辑时从服务器载入图片, 或者从内存中加载图片
				currLoadState.loadingImg();
			else if (CoreApp.isAIR)
				currLoadState.loadingImg();
			
		}
		
		private var rendered:Boolean;
		
		/**
		 * 
		 * 元素的原始尺寸 乘以 缩放比例  = 实际尺寸；
		 * 
		 */		
		override public function get scaledWidth():Number
		{
			return vo.width * vo.scale;		
		}
		
		/**
		 */		
		override public function get scaledHeight():Number
		{
			return vo.height * vo.scale;
		}
		
		/**
		 */		
		override public function del():void
		{
			dispatchEvent(new ElementEvent(ElementEvent.DEL_IMG, this));
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return null;
		}
		
		/**
		 */		
		override protected function init():void
		{
			preRender();
			render();
		}
		
		/**
		 */		
		internal function createLoading():void
		{
			if(!loading) 
			{
				loading = new Loading;
				//loading.scaleX = loading.scaleY = imgVO.scale
				
				addChild(loading);
			}
			
			loading.play();
		}
		
		/**
		 */		
		public function removeLoading():void
		{
			if (loading) 
			{
				if (contains(loading)) 
					removeChild(loading)
				
				loading.stop();
				loading = null;
			}
		}
		
		/**
		 */		
		private var loading:Loading;
		
		/**
		 */		
		internal function drawLoading():void
		{
			graphics.clear();
			graphics.beginFill(0x555555, 0.3);
			graphics.drawRect( - vo.width / 2, - vo.height / 2, vo.width, vo.height);
			graphics.endFill();
			
			createLoading();
		}
		
		/**
		 */		
		public function get imgVO():ImgVO
		{
			return vo as ImgVO;
		}
		
		/**
		 */		
		internal var currLoadState:ImgLoadStateBase;
		internal var loadingState:ImgLoadStateBase;
		internal var normalState:ImgLoadStateBase;
	}
}