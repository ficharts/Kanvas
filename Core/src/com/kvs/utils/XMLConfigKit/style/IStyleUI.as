package com.kvs.utils.XMLConfigKit.style
{
	import flash.events.IEventDispatcher;

	public interface IStyleUI extends IEventDispatcher
	{
		function render():void;
		
		function get style():Style;
		function set style(value:Style):void;
		
		function set mdata(value:Object):void;
		function get mdata():Object;
	}
}