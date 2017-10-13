package fr.kapit.lab.demo.elasticsearch.model
{
import com.hurlant.crypto.hash.HMAC;
import com.hurlant.crypto.hash.SHA256;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.ByteArray;

import flashx.textLayout.debug.assert;

import fr.kapit.elasticsearch.ElasticSearch;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.formatters.DateFormatter;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;
import mx.utils.Base64Encoder;
import mx.utils.ObjectUtil;

public class ApplicationModel extends EventDispatcher
{
	private const AWS_HOST:String = "ecs.amazonaws.com";
	private const AWS_METHOD:String = "GET";
	private const AWS_PATH:String = "/onca/xml";

	private var amazonDeveloperId:String = "AKIAIZWT7KZQB4VKSSWQ";
	private var amazonSecretAccessKey:String = "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";
	private var amazonAffiliateId:String = "ki03d-20";
	private var amazonSearch:HTTPService;
	private var amazonRequest:Object;
	private var amazonTimeStamp:String;
	private var signature:String;

	[Bindable] public var dataProvider:Array;

	/*
	 * normal || loaded || empty
	 */
	[Bindable] public var viewState:String = "normal";

	[Bindable] public var progress:uint;

	public var maxPages:uint = 10;

	private var _source:Array;
	private var _amazonCurrentPage:uint;
	private var _searchTag:String;
	private var elasticSearch:ElasticSearch;

	public function ApplicationModel()
	{
		amazonSearch = new HTTPService();
		amazonSearch.url = "http://ecs.amazonaws.com/onca/xml";
		amazonSearch.requestTimeout = 20;
		amazonSearch.showBusyCursor = true;
		amazonSearch.resultFormat = "object";
		amazonRequest = {
			AWSAccessKeyId:amazonDeveloperId,
			AssociateTag:amazonAffiliateId,
			Operation:"ItemSearch",
			ResponseGroup:"ItemAttributes,Images,Tracks,EditorialReview,Reviews",
			SearchIndex:"Books",
			Service : "AWSECommerceService",
			Keywords : "",
			ItemPage : "1",
			Signature : "",
			Timestamp : "",
			Version:"2009-03-31"
		};
		amazonSearch.request = amazonRequest;
		amazonSearch.addEventListener(ResultEvent.RESULT, onSearchResult);
		amazonSearch.addEventListener(FaultEvent.FAULT, onSearchFault);
	}

	public function cancel():void
	{
		amazonSearch.cancel();
		amazonSearch = null;
		reset();
	}

	[Bindable(event="dataProviderChanged")]
	public function get books():ArrayList
	{
		return new ArrayList(ObjectUtil.clone(dataProvider) as Array)
	}

	public function get searchTag():String
	{
		return _searchTag;
	}
	/**
	 * @private
	 */
	public function set searchTag(value:String):void
	{
		_searchTag = (value.indexOf("'") != -1) ? value.replace(/\u0027+/g, " ") : value;
		search();
	}

	protected function onSearchFault(event:FaultEvent):void
	{

	}

	protected function onSearchResult(event:ResultEvent):void
	{
		const max:uint = Math.min(event.result.ItemSearchResponse.Items.TotalPages, maxPages);
		const details:ArrayCollection = event.result.ItemSearchResponse.Items.Item as ArrayCollection;
		if (details)
		{
			if (!_source)
				_source = [];

			var l:uint = details.length;
			var b:AmazonBook;
			var i:uint=0;
			while (++i < l)
			{
				b = getAmazonBook(details[i]);
				if (b)
					_source.push(b);
			}

			if (_amazonCurrentPage < max)
			{
				_amazonCurrentPage++;
				progress = _amazonCurrentPage / max * 100;
				search(false);
			}
		}
		if (!details || !max || _amazonCurrentPage == max)
		{
			progress = 100;
			dataProvider = _source;
			viewState = _source ? "loaded" : "empty";
			dispatchEvent(new Event("dataProviderChanged"));
		}
	}

	protected function getAmazonBook(item:Object):AmazonBook
	{
		const items:Object = item.ItemAttributes;
		if (!items.Languages || !items.Languages.Language.length)
			return null;

		var book:AmazonBook = new AmazonBook;
		book.title = items.Title;
		book.author = items.Author;
		book.edition = items.Edition;
		book.publisher = items.Publisher;
		book.numberOfPages = items.NumberOfPages;
		book.image = (item.MediumImage) ? item.MediumImage.URL : null;
		book.publishingDate = String(items.PublicationDate).substr(0,4);
		book.language = items.Languages.Language[0].Name;
		book.price = items.ListPrice ? String(items.ListPrice.Amount / 100) : "N/D";

		if (item.EditorialReviews && item.EditorialReviews.EditorialReview)
			book.description = htmlDecode(trim(item.EditorialReviews.EditorialReview.length ? item.EditorialReviews.EditorialReview[0].Content : item.EditorialReviews.EditorialReview.Content));
		if (!book.description || !book.description.length)
			book.description = "N/D";

		return book;
	}

	protected function search(doReset:Boolean=true):void
	{
		if (doReset)
			reset();

		amazonTimeStamp = getTimestamp();
		amazonRequest.Timestamp = amazonTimeStamp;
		amazonRequest.Keywords = _searchTag;
		amazonRequest.Signature = getSignature();
		amazonSearch.send();
	}

	private function reset():void
	{
		dataProvider = null;
		_source = null;
		viewState = "normal";
		progress = _amazonCurrentPage = 0;
		dispatchEvent(new Event("dataProviderChanged"));
	}

	private function getSignature():String
	{
		var parameterArray:Array = [];
		var parameterCollection:ArrayCollection = new ArrayCollection();
		var parameterString:String = "";
		var sort:Sort = new Sort();
		var hmac:HMAC = new HMAC(new SHA256());
		var requestBytes:ByteArray = new ByteArray();
		var keyBytes:ByteArray = new ByteArray();
		var hmacBytes:ByteArray;
		var encoder:Base64Encoder = new Base64Encoder();
		var formatter:DateFormatter = new DateFormatter();
		var now:Date = new Date();


		var key:String;
		var urlEncodedKey:String;
		var parameterBytes:ByteArray;
		var valueBytes:ByteArray;
		var value:String;
		var urlEncodedValue:String;
		for (key in amazonRequest)
		{
			if (key != "Signature")
			{
				urlEncodedKey = encodeURIComponent(decodeURIComponent(key));
				parameterBytes = new ByteArray();
				valueBytes = new ByteArray();
				if(key != "ItemPage")
					value = amazonRequest[key];
				else
					value = amazonRequest[key] = (_amazonCurrentPage + 1).toString();
				urlEncodedValue = encodeURIComponent(decodeURIComponent(value.replace(/\+/g, "%20")));
				parameterBytes.writeUTFBytes(urlEncodedKey);
				valueBytes.writeUTFBytes(urlEncodedValue);
				parameterCollection.addItem( { parameter : parameterBytes , value : valueBytes } );
			}
		}

		// Sort the parameters and formulate the parameter string to be signed.
		parameterCollection.sort = sort;
		sort.fields = [ new SortField("parameter", false), new SortField("value", true) ];
		parameterCollection.refresh();

		parameterString = AWS_METHOD + "\n" + AWS_HOST + "\n" + AWS_PATH + "\n";
		var l:uint = parameterCollection.length;
		var i:Number = 0;
		var pair:Object;
		for (i; i < l; i++)
		{
			pair = parameterCollection.getItemAt(i);

			parameterString += pair.parameter + "=" + pair.value;

			if (i < l - 1)
				parameterString += "&";
		}

		requestBytes.writeUTFBytes(parameterString);
		keyBytes.writeUTFBytes(amazonSecretAccessKey);
		hmacBytes = hmac.compute(keyBytes, requestBytes);
		encoder.encodeBytes(hmacBytes);
		signature = encodeURI(encoder.toString());
		return signature;
	}

	private function getTimestamp():String
	{
		var now:Date = new Date();
		var month:String = (now.monthUTC+1).toString().length ==2?(now.monthUTC+1).toString():"0"+(now.monthUTC+1).toString();
		var date:String = now.dateUTC.toString().length ==2?now.dateUTC.toString():"0"+now.dateUTC.toString();
		var hour:String = now.hoursUTC.toString().length==2?now.hoursUTC.toString():"0"+now.hoursUTC.toString();
		var minutes:String = now.minutesUTC.toString().length==2?now.minutesUTC.toString():"0"+now.minutesUTC.toString();
		var seconds:String = now.secondsUTC.toString().length==2?now.secondsUTC.toString():"0"+now.secondsUTC.toString();

		return now.fullYearUTC+'-'+month+"-"+date+"T"+hour+":"+minutes+":"+seconds+".000Z";
	}

	private function htmlDecode(value:String):String
	{
		return value.replace(/<.+>/i, "");
	}

	private function trim(value:String):String
	{
		return value ? value.replace(/\s+$/, "").replace(/^\s+/, "") : null;
	}
}
}