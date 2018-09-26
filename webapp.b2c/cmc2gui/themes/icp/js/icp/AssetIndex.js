function AssetIndex() {
	/* assets is a hash structure like
		{
			<CTN>: {
				<code>: {
					<type>: {code: ..., type: ..., width: ..., height: ...},
					<type>: ...
				},
				<code>: {
					...
				}
			}
		}
	*/
	this.assets = {};
	this.imageSets = {
		// A subset of the GAL image set (master types)
		GAL: ['PPW','RFT','FTL','FTR','PUW','__F','_FT','RCO','PDP'],
		// The IMS image set
		IMS: ['PUW','__F','_FT','PPW','RFT','FTL','FTR']
	}
	// masters is an index of child types for every master that is added
	this.masters = {};
}

// Add an asset object {code: ..., type: ..., ...} to the index.
AssetIndex.prototype.addAsset = function(ownerId, asset) {
	if (typeof this.assets[ownerId] === "undefined") {
		this.assets[ownerId] = {};
	}
	var code = this.escape(asset.code);
	
	if (typeof this.assets[ownerId][code] === "undefined") {
		this.assets[ownerId][code] = {};
	}
	
	this.assets[ownerId][code][asset.type] = asset;
	
	// Add it to the masters index
	if (typeof asset.master !== "undefined") {
		if (typeof this.masters[asset.master] === "undefined") {
			this.masters[asset.master] = [];
		}
		if (!this.masters[asset.master].toString().match(asset.type)) {
			this.masters[asset.master].push(asset.type);
		}
	}
}

/*
	Get a specific Asset.
	
	Examples:
	
	ai.getAsset("42PFL9903H/12", "RTP");
	ai.getAsset("42PFL9903H/12", "F300000253", "RTP");
*/
AssetIndex.prototype.getAsset = function(ownerId, codeOrType, type) {
	var asset = null;
	if (typeof this.assets[ownerId] !== "undefined") {
	 var code = this.escape(arguments.length > 2 ? codeOrType : ownerId);
	 var type = arguments.length > 2 ? type : codeOrType;
	 if (typeof this.assets[ownerId][code] !== "undefined"
				&& typeof this.assets[ownerId][code][type] !== "undefined") {
		asset = this.assets[ownerId][code][type];
	 }
	}
	return asset;
}

AssetIndex.prototype.escape = function(s) {
	return s.replace(/[\/-]/g, "_");
}

/*
	Find an asset for a given owner (CTN).
	query is an object that must have a 'type' property, which indicates the doc type to find. The type can be either a master
	type or one of the master's derived types. If it is a derived type the requested owner *must* have an asset of that type,
	otherwise no asset will be found.
	query should also have a 'width' and/or 'height' and a 'code' property.
	The 'code' property specifies an asset code, e.g. a feature code. If it is empty the escaped ownerId will be used.
	
	Examples:
	
	// Standard product photograph, selected by master type
	ai.findAsset('42PFL9903H/12', {type: 'RFT', width: 50, height: 50});
	
	// Standard product photograph, selected by a derived type
	ai.findAsset('42PFL9903H/12', {type: 'RTP', width: 50, height: 50});
	
	// Feature logo, selected by master type
	ai.findAsset('42PFL9903H/12', {code: 'F300000253', type: 'FLO', width: 50, height: 50});
	
*/
AssetIndex.prototype.findAsset = function(ownerId, query) {
	var result;
	var queryType = query.type || "";
	if (ownerId != "" && queryType !== "") {
		var code = this.escape(query.code || ownerId);
		var w = query.width | 0;
		var h = query.height | 0;
		if (typeof this.assets[ownerId] !== "undefined"
				&& typeof this.assets[ownerId][code] !== "undefined") {
			if (query.type === "GAL" || query.type === "IMS") {
				// Try to get an asset by iterating all types in the set
				var set = this.imageSets[query.type];
				for (var i=0; i<set.length && typeof(result) === "undefined"; i++) {
					if (typeof this.masters[set[i]] !== "undefined") {
						result = this.getSuitableAsset(this.getAssetsForMaster(this.assets[ownerId][code], set[i]), w, h);
					}
				}
			}
			else if (typeof this.masters[query.type] !== "undefined") {
				// query.type is a master type
				result = this.getSuitableAsset(this.getAssetsForMaster(this.assets[ownerId][code], query.type), w, h);
			}
			else {
				// query.type is a derived type: get the master type
				var asset = this.assets[ownerId][code][query.type];
				if (typeof asset !== "undefined") {
					result = this.getSuitableAsset(this.getAssetsForMaster(this.assets[ownerId][code], asset.master), w, h);
				}
			}
		}
	}
	return typeof(result) !== "undefined" ? result : null;
}

/*
	Find an asset whose dimensions best fit the requested dimensions.
	assets is an Array of asset objects.
*/
AssetIndex.prototype.getSuitableAsset = function(assets, width, height) {
	var distance, idx;
	for (var i=0; i<assets.length; i++) {
		var a = assets[i];
		if (typeof a.width === "undefined" || a.width === ""
				|| typeof a.height === "undefined" || a.height === "") {
			continue;
		}
		if (!a.extension == "jpg") {
			continue;
		}
		var d = 0;
		if (width > 0)
			d += Math.abs(width - a.width);
		if (height > 0)
			d += Math.abs(height - a.height);
		if (typeof(distance) === "undefined" || d < distance) {
			distance = d;
			idx = i;
		}
	}
	return assets[idx];
}

// Filter an asset hash based on a master doc type
// Asset hash is keyed on doc type
AssetIndex.prototype.getAssetsForMaster = function(assets, masterType) {
	var assetList = [];
	var master = this.masters[masterType];
	for (var i=0; i<master.length; i++) {
		if (typeof assets[master[i]] !== "undefined") {
			assetList.push(assets[master[i]]);
		}
	}
	return assetList;
}
