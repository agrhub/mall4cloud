## Protect against `xss` attacks

In order to prevent users from passing in some fake data and fake scripts to attack the system, the most famous one is the `xss` attack. Therefore, this mall uses filters in the background code to solve the `xss` attack.

In the `mall4cloud` project, a filter `XssFilter` is used

```java
public class XssFilter implements Filter {

	private static final Logger logger = LoggerFactory.getLogger(XssFilter.class);

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse resp = (HttpServletResponse) response;
		// replaceAll("[\r\n]" =》 Potential CRLF Injection for logs
		logger.info("AuthFilter RequestURI :{}", req.getRequestURI().replaceAll("[\r\n]",""));
		// xss 过滤
		chain.doFilter(new XssWrapper(req), resp);
	}
}
```

It mainly performs a series of filtering through the `new XssWrapper(req)` object, while `XssWrapper` performs a series of filtering of user input through `Jsoup`. After all, professional things should be left to professional people. In this regard, we have completed the defense against **xss attacks** through simple settings.

```java
public class XssWrapper extends HttpServletRequestWrapper {

	/**
	 * Constructs a request object wrapping the given request.
	 * @param request The request to wrap
	 * @throws IllegalArgumentException if the request is null
	 */
	public XssWrapper(HttpServletRequest request) {
		super(request);
	}

	/**
	 * 对数组参数进行特殊字符过滤
	 */
	@Override
	public String[] getParameterValues(String name) {
		String[] values = super.getParameterValues(name);
		if (values == null) {
			return null;
		}
		int count = values.length;
		String[] encodedValues = new String[count];
		for (int i = 0; i < count; i++) {
			encodedValues[i] = cleanXss(values[i]);
		}
		return encodedValues;
	}

	/**
	 * 对参数中特殊字符进行过滤
	 */
	@Override
	public String getParameter(String name) {
		String value = super.getParameter(name);
		if (StrUtil.isBlank(value)) {
			return value;
		}
		return cleanXss(value);
	}

	/**
	 * 获取attribute,特殊字符过滤
	 */
	@Override
	public Object getAttribute(String name) {
		Object value = super.getAttribute(name);
		if (value instanceof String && StrUtil.isNotBlank((String) value)) {
			return cleanXss((String) value);
		}
		return value;
	}

	/**
	 * 对请求头部进行特殊字符过滤
	 */
	@Override
	public String getHeader(String name) {
		String value = super.getHeader(name);
		if (StrUtil.isBlank(value)) {
			return value;
		}
		return cleanXss(value);
	}

	private String cleanXss(String value) {
		return XssUtil.clean(value);
	}
}
```

The main method here is `XssUtil.clean(value)` -> `Jsoup.clean(content, "", WHITE_LIST, OUTPUT_SETTINGS)` The most important one is a whitelist list `WHITE_LIST`, the whitelist list There are some tags that carry html to enter, so as to prevent xss attacks.

```java
new Whitelist().addTags(
                        "a", "b", "blockquote", "br", "caption", "cite", "code", "col",
                        "colgroup", "dd", "div", "dl", "dt", "em", "h1", "h2", "h3", "h4", "h5", "h6",
                        "i", "img", "li", "ol", "p", "pre", "q", "small", "span", "strike", "strong",
                        "sub", "sup", "table", "tbody", "td", "tfoot", "th", "thead", "tr", "u",
                        "ul")
                .addAttributes("a", "href", "title")
                .addAttributes("blockquote", "cite")
                .addAttributes("col", "span", "width")
                .addAttributes("colgroup", "span", "width")
                .addAttributes("img", "align", "alt", "height", "src", "title", "width")
                .addAttributes("ol", "start", "type")
                .addAttributes("q", "cite")
                .addAttributes("table", "summary", "width")
                .addAttributes("td", "abbr", "axis", "colspan", "rowspan", "width")
                .addAttributes(
                        "th", "abbr", "axis", "colspan", "rowspan", "scope",
                        "width")
                .addAttributes("ul", "type")
                .addProtocols("a", "href", "ftp", "http", "https", "mailto")
                .addProtocols("blockquote", "cite", "http", "https")
                .addProtocols("cite", "cite", "http", "https")
                .addProtocols("img", "src", "http", "https")
                .addProtocols("q", "cite", "http", "https")
```

