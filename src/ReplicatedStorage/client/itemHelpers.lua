local itemHelpers = {}

export type itemType = {
    Id: number,
    Name: string,
    Price: number?,
    LowestPrice: number?,
    CreatorName: string?,
    CreatorTargetId: number?,
    AssetType: Enum.AvatarAssetType?,
    ItemType: Enum.MarketplaceProductType?,
}

export type itemsType = {
    itemType
}

function itemHelpers.getID(item: itemType) : number
    local id = item.Id    
    return id
end

function itemHelpers.getName(item: itemType) : string
    local name = item.Name
    return name
end

function itemHelpers.getBestPrice(item : itemType) : number
    local basePrice = item.Price
    local resellPrice = item.LowestPrice

    local bestPrice

    if basePrice and resellPrice then
        bestPrice = math.min(basePrice, resellPrice)

    elseif basePrice or resellPrice then
        bestPrice = basePrice or resellPrice
        
    else
        local name = itemHelpers.getName(item)
        warn("Failed to get price for " .. name)

        bestPrice = 0
    end

    return bestPrice
end

return itemHelpers