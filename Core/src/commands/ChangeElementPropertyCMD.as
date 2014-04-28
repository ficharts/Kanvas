package commands
{
	import com.kvs.utils.PerformaceTest;
	
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.ElementBase;
	import view.element.GroupElement;
	import view.element.PageElement;
	import view.element.imgElement.ImgElement;
	import view.elementSelector.ElementSelector;
	import view.interact.multiSelect.TemGroupElement;

	/**
	 * 改变元件的属性
	 */	
	public final class ChangeElementPropertyCMD extends Command
	{
		public function ChangeElementPropertyCMD()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			
			element  = CoreFacade.coreMediator.currentElement;
			if (element)
			{
				selector = CoreFacade.coreMediator.selector;
				
				oldPropertyObj = notification.getBody();
				
				newPropertyObj = {};
				
				for (var propertyName:String in oldPropertyObj) 
				{
					if (propertyName == "indexChangeElement")
					{
						newPropertyObj["indexChangeElement"] = oldPropertyObj["indexChangeElement"];
					}
					else if (propertyName == "index")
					{
						//获取改变层级元素的新层级关系
						var layer:Vector.<int> = new Vector.<int>;
						var length:int =  oldPropertyObj["indexChangeElement"].length;
						
						for (var i:int = 0; i <　length; i++)
							layer[i] = oldPropertyObj["indexChangeElement"][i].index;
						
						newPropertyObj[propertyName] = layer;
					}
					else if (customPropertyNames[propertyName])
					{
						newPropertyObj[propertyName] = element.vo[propertyName];
					}
					else
					{
						newPropertyObj[propertyName] = element[propertyName];
					}
				}
				
				groupElements = CoreFacade.coreMediator.autoGroupController.elements;
				
				autoGroupEnabled = CoreFacade.coreMediator.autoGroupController.enabled;
				
				setProperty(newPropertyObj, true);
				
				UndoRedoMannager.register(this);
			}
		}
		
		override public function undoHandler():void
		{
			element.clearHoverEffect();
			setProperty(oldPropertyObj);
		}
		
		override public function redoHandler():void
		{
			element.clearHoverEffect();
			setProperty(newPropertyObj);
		}
		
		/**
		 * 
		 * @param obj
		 * @param exec 是否是执行，而不是撤销与重做。
		 * 
		 */
		private function setProperty(obj:Object, exec:Boolean = false):void
		{
			var group:Boolean = ((element is TemGroupElement) || (element is GroupElement));
			
			//变化前检测需要刷新的pages
			if (exec)
			{
				if(!(element is PageElement))
				{
					reset(element);
					CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(element);
				}
			}
			
			for (var propertyName:String in obj) 
			{
				try
				{
					if (propertyName == "index")
					{
						CoreFacade.coreMediator.autoLayerController.swapElements(obj["indexChangeElement"], obj[propertyName]);
					}
					else if (propertyName == "indexChangeElement") { }
					else
					{
						if (element.vo.hasOwnProperty(propertyName))
							element.vo[propertyName] = obj[propertyName];
					}
				}
				catch (e:Error)
				{
					trace(e.getStackTrace());
				}
			}
			
			
			if ((element.autoGroupChangable && autoGroupEnabled) || group)
			{
				CoreFacade.coreMediator.autoGroupController.resetElements(groupElements);
				
				var newObj:Object = obj;
				var oldObj:Object = (obj == newPropertyObj) ? oldPropertyObj : newPropertyObj;
				
				//变化前检测需要刷新的pages
				if (exec)
				{
					for each (var item:ElementBase in CoreFacade.coreMediator.autoGroupController.elements)
					{
						if(!(item is PageElement))
						{
							resetGroupItem(item);
							CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(item);
						}
					}
				}
				
				if (obj["x"] != undefined && obj["y"] != undefined && (obj["width"] == undefined && obj["height"] == undefined))
				{
					CoreFacade.coreMediator.autoGroupController.moveTo(newObj.x - oldObj.x, newObj.y - oldObj.y, group);
				}
				if (obj["rotation"] != undefined)
				{
					CoreFacade.coreMediator.autoGroupController.rollTo(newObj.rotation - oldObj.rotation, element, group);
				}
				if (obj["scale"] != undefined)
				{
					CoreFacade.coreMediator.autoGroupController.scaleTo(newObj.scale / oldObj.scale, element, group);
				}
				
				//变化后检测需要刷新的pages
				if (exec)
				{
					for each (item in CoreFacade.coreMediator.autoGroupController.elements)
					{
						if (item is PageElement)
							CoreFacade.coreMediator.pageManager.registUpdateThumbVO(item.vo as PageVO);
						else
							CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(item);
					}
				}
			}
			
			element.render();
			selector.update();
			
			
			//变化后检测需要刷新的pages
			///PerformaceTest.start("setProperty() element updatePageThumbs");
			if (exec)
			{
				if (element is PageElement)
					CoreFacade.coreMediator.pageManager.registUpdateThumbVO(element.vo as PageVO);
				else
					CoreFacade.coreMediator.pageManager.registOverlappingPageVOs(element);
				v = CoreFacade.coreMediator.pageManager.refreshVOThumbs();
			}
			else
			{
				CoreFacade.coreMediator.pageManager.refreshVOThumbs(v);
			}
			///PerformaceTest.end("setProperty() element updatePageThumbs");
			
			this.dataChanged();
		}
		
		private function reset(item:ElementBase):void
		{
			for (var propertyName:String in oldPropertyObj) 
			{
				if (propertyName == "index") { }
				else if (propertyName == "indexChangeElement") { }
				else
				{
					if (item.hasOwnProperty(propertyName))
					{
						item[propertyName] = oldPropertyObj[propertyName];
					}
					else
					{
						item.vo[propertyName] = oldPropertyObj[propertyName];
					}
				}
			}
		}
		
		private function resetGroupItem(item:ElementBase):void
		{
			for (var propertyName:String in oldPropertyObj) 
			{
				if (thumbPropertyNames[propertyName])
				{
					item[propertyName] = item.vo[propertyName];
				}
			}
		}
		
		/**
		 */		
		private var oldPropertyObj:Object;
		
		/**
		 */		
		private var newPropertyObj:Object;
		
		/**
		 */	
		private var groupElements:Vector.<ElementBase>;
		
		/**
		 */		
		private var element:ElementBase;
		
		/**
		 */	
		private var autoGroupEnabled:Boolean;
		
		/**
		 */		
		private var selector:ElementSelector;
		
		private var v:Vector.<PageVO>;
		
		private static const thumbPropertyNames:Object = 
		{
			x:true, 
			y:true, 
			width:true, 
			height:true, 
			scale:true, 
			rotation:true
		};
		private static const customPropertyNames:Object = 
		{
			radius:true, 
			arrowWidth:true, 
			trailHeight:true, 
			r:true, 
			rAngle:true, 
			innerRadius:true, 
			width:true, 
			height:true, 
			arc:true,
			thickness:true
		};
	}
}