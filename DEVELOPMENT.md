# Development Guide

This guide is for developers who want to contribute to or extend the SoldBy userscript.

## Project Structure

```
soldby/
├── .github/
│   └── ISSUE_TEMPLATE/     # GitHub issue templates
├── assets/                 # Project assets
├── userscript/
│   ├── img/               # Images (icons, etc.)
│   ├── gm_config.js       # GM_config library (self-hosted)
│   ├── README.md          # Userscript-specific documentation
│   └── soldby.user.js     # Main userscript file
├── CHANGELOG.md           # Version history
├── DEVELOPMENT.md         # This development guide
├── LICENSE                # MIT License
├── README.md              # Main documentation
└── validate.sh            # Validation script
```

## Architecture

### Core Components

1. **GM_config** - Configuration management UI
   - Settings stored via GM.getValue/GM.setValue
   - User-configurable countries to highlight
   - Cache expiration settings

2. **Product Detection** - Identifies Amazon products on page
   - Uses MutationObserver to detect dynamic content
   - Extracts ASIN (Amazon Standard Identification Number)
   - Multiple selector strategies for different page layouts

3. **Seller Information Fetching**
   - Fetches product pages to extract seller ID and name
   - Fetches seller profile pages for country and ratings
   - Implements caching in localStorage to reduce requests

4. **Display & Highlighting**
   - Injects seller info boxes next to product titles
   - Highlights products from configured countries
   - Optionally hides highlighted products

### Data Flow

```
Page Load → Detect Products → Check Cache
                                   ↓
                            Cache Hit? 
                            ↙        ↘
                          Yes        No
                           ↓          ↓
                    Display Info   Fetch Data → Cache → Display Info
```

## Making Changes

### Development Workflow

1. **Local Testing**
   - Install a userscript manager (Violentmonkey or Tampermonkey)
   - Edit `userscript/soldby.user.js` locally
   - Install the script from local file
   - Test on Amazon product pages

2. **Testing Checklist**
   - [ ] Product listing pages (search results)
   - [ ] Individual product pages
   - [ ] Carousels and recommendations
   - [ ] Settings panel opens and saves
   - [ ] Cache works correctly
   - [ ] Highlighting works for configured countries

3. **Before Committing**
   - Check JavaScript syntax: `node -c userscript/soldby.user.js`
   - Update version number in the userscript header
   - Update CHANGELOG.md
   - Test on at least 2 Amazon domains

### Key Selectors

Amazon's DOM changes frequently. If the script stops working, these selectors likely need updating:

**Product containers:**
- `div[data-asin]` - Main product identifier
- `.s-result-item` - Search result items
- `.a-carousel-card` - Carousel items

**Seller information:**
- `#sellerProfileTriggerId` - Seller profile link
- `#merchant-info` - Merchant information box
- `#tabular-buybox` - Buy box with seller info

**Seller profile page:**
- `#page-section-detail-seller-info` - Seller details section

### Performance Considerations

- **Caching Strategy**: Products are cached for 1 day, sellers for 7 days
- **Request Throttling**: Amazon may return 503 errors if too many requests
- **MutationObserver**: Fires on every DOM change - be mindful of performance
- **localStorage Limits**: Typically 5-10MB per domain

## Security

### Current Protections

- ✅ Uses `JSON.stringify()` for safe serialization
- ✅ Sanitizes seller names (replaces quotes)
- ✅ Uses `textContent` instead of `innerHTML` where possible
- ✅ Validates response status before parsing

### Security Checklist

When adding new features:
- [ ] Never use `eval()` or `Function()` constructor
- [ ] Sanitize all user input and external data
- [ ] Use `textContent` or `createElement()` instead of `innerHTML`
- [ ] Validate URLs before making fetch requests
- [ ] Be cautious with `localStorage` - don't store sensitive data

## Dependencies

- **GM_config** - Settings UI (hosted in this repository at `userscript/gm_config.js`)
- **GM.getValue/setValue** - Storage API (provided by userscript manager)
- **Fetch API** - HTTP requests (native browser API)
- **DOMParser** - HTML parsing (native browser API)
- **MutationObserver** - DOM change detection (native browser API)

## Compatibility

### Browser Support

- Firefox 148+
- Chrome 145+
- Edge, Safari, Opera (with compatible userscript manager)

### Userscript Managers

- Violentmonkey 2.19+ (recommended)
- Tampermonkey 5.3+
- Greasemonkey (limited support)

### Amazon Domains

Currently supports 12 Amazon marketplaces. See README.md for the full list.

## Extending Functionality

### Adding New Features

When extending the userscript:

1. **Maintain Core Functionality** - Don't break existing features
2. **Use Caching** - Minimize requests to Amazon
3. **Handle Errors** - Amazon's markup changes frequently
4. **Test Thoroughly** - Test on multiple page types and domains
5. **Update Documentation** - Update README and CHANGELOG

### Feature Ideas

Some ideas for future extensions:
- Filter/sort by seller country
- Price history tracking
- Seller reputation scores
- Export seller data
- Integration with other Amazon tools
- Mobile support
- Dark mode for settings panel

## Troubleshooting

### Common Issues

**Script not working:**
- Check if external CDN is accessible (jsDelivr)
- Verify userscript manager is enabled
- Check browser console for errors
- Clear localStorage and test again

**503 Errors:**
- Amazon is rate-limiting requests
- Cache should reduce this issue
- Wait a few minutes before trying again

**Seller info not showing:**
- Amazon changed their DOM structure
- Update selectors in the code
- Check if seller profile is accessible

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - See LICENSE file for details
