## Swagger documentation

> Whether it is knife4j or swagger-bootstrap-ui, the address provided to the outside world is still doc.html
>
> The access path to the documentation of this mall: `domain name + port +/doc.html`, for example: http://localhost:8000/doc.html

​ Note: 8000 is the port of the gateway of the mall

> Knife4j is an enhanced solution to generate Api documentation for Java MVC framework integrating Swagger, formerly swagger-bootstrap-ui.

[swagger official website](https://swagger.io/)

[knife4j official documentation][https://xiaoym.gitee.io/knife4j/documentation/]

### Add dependencies

```
<knife4j.version>3.0.2</knife4j.version>

<dependency>
	<groupId>com.github.xiaoymin</groupId>
	<artifactId>knife4j-micro-spring-boot-starter</artifactId>
	<version>${knife4j.version}</version>
</dependency>
<dependency>
	<groupId>com.github.xiaoymin</groupId>
	<artifactId>knife4j-spring-boot-starter</artifactId>
	<version>${knife4j.version}</version>
</dependency>
```

### Add configuration class and enable

In the **config** folder of each microservice module in this mall, there is a corresponding configuration class for swagger. Taking the rbac module as an example, the configuration is as follows:

```java
@Configuration
@EnableSwagger2
@EnableKnife4j
public class SwaggerConfiguration {

	@Bean
	public Docket baseRestApi() {
		return new Docket(DocumentationType.SWAGGER_2).apiInfo(apiInfo()).select()
				.apis(RequestHandlerSelectors.basePackage("com.mall4j.cloud.rbac.controller")).paths(PathSelectors.any())
				.build();
	}

	@Bean
	public ApiInfo apiInfo() {
		return new ApiInfoBuilder().title("mall4cloud商城接口文档").description("mall4cloud商城接口文档Swagger版").termsOfServiceUrl("")
				.contact(new Contact("广州市蓝海创新科技有限公司", "", "")).version("1.0").build();
	}
}
```

It should be noted that the api file, which is the path of the controller package, is configured in the class, otherwise the generated document cannot scan the interface successfully.

```java
.apis(RequestHandlerSelectors.basePackage("com.mall4j.cloud.rbac.controller"))
```

Annotate the class with `@Configuration` to let spring manage this class

Annotating a method with `@Bean` is equivalent to configuring a bean in XML

Use the `@EnableSwagger2` flag to enable `Swagger2`

Use the `@EnableKnife4j` flag to enable `Knife4j`

### Interface usage

After configuration, we can use swagger, such as in the `SpuTagController` class

```java
@RestController("appSpuTagController")
@RequestMapping("/ua/spu_tag")
@Api(tags = "商品分组表")
public class SpuTagController {

    @Autowired
    private SpuTagService spuTagService;

    @GetMapping("/list")
    @ApiOperation(value = "获取商品分组列表", notes = "获取商品分组列表")
    @ApiImplicitParam(name = "shopId", value = "店铺id", dataType = "Long")
    public ServerResponseEntity<List<SpuTagVO>> list(@RequestParam(value = "shopId", defaultValue = "0") Long shopId) {
        List<SpuTagVO> categories = spuTagService.listByShopId(shopId);
        return ServerResponseEntity.success(categories);
    }
}
```

`@Api(tags="product grouping table")` defines the tag grouping interface, all interfaces defined under this class will be located under this tag

`@ApiOperation(value = "Get product grouping list", notes = "Get product grouping list")`Define specific interface title information, notes can add comments to this label

`@ApiImplicitParam(name = "shopId", value = "shop id", dataType = "Long")` The corresponding parameter list information is returned to the front-end developer by the back-end. What parameters and parameter descriptions need to be passed in this interface

If there are multiple parameters that need to be explained, you can use `@ApiImplicitParams()` The following can contain multiple `@ApiImplicitParam()`

E.g:

```java
@ApiImplicitParams({
            @ApiImplicitParam(name = "parentId", value = "分类ID", dataType = "Long"),
            @ApiImplicitParam(name = "shopId", value = "店铺id", dataType = "Long")
    })
```

### Entity class

```java
public class ChangeShopCartItemDTO {

    @ApiModelProperty(value = "购物车ID", required = true)
    private Long shopCartItemId;

    @NotNull(message = "商品ID不能为空")
    @ApiModelProperty(value = "商品ID", required = true)
    private Long spuId;

    @ApiModelProperty(value = "旧的skuId 如果传过来说明在变更sku", required = true)
    private Long oldSkuId;

    @NotNull(message = "skuId不能为空")
    @ApiModelProperty(value = "skuId", required = true)
    private Long skuId;

    @ApiModelProperty(value = "店铺ID，前端不用传该字段")
    private Long shopId;

    @NotNull(message = "商品个数不能为空")
    @ApiModelProperty(value = "商品个数", required = true)
    private Integer count;

    @ApiModelProperty(value = "商品是否勾选 true：勾选 ")
    private Boolean isCheck;
    
    一系列GET、SET、ToString方法。
}
```

`@ApiModelProperty(value = "Shopping Cart ID", required = true)` This annotation can be used to tell front-end developers what the field represents and whether it is required to be passed.

### Common Notes

| 注解               | 作用                                 |
| ------------------ | ------------------------------------ |
| @Api               | 修饰整个类，描述Controller的作用     |
| @ApiOperation      | 描述一个类的一个方法，或者说一个接口 |
| @ApiParam          | 单个参数描述                         |
| @ApiModel          | 用对象来接收参数                     |
| @ApiProperty       | 用对象接收参数时，描述对象的一个字段 |
| @ApiResponse       | HTTP响应其中1个描述                  |
| @ApiResponses      | HTTP响应整体描述                     |
| @ApiIgnore         | 使用该注解忽略这个API                |
| @ApiError          | 发生错误返回的信息                   |
| @ApiImplicitParam  | 一个请求参数                         |
| @ApiImplicitParams | 多个请求参数                         |
