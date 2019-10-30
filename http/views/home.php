<?=view('templates.header', ['title' => 'Home'])?>

<div class="container">
    <h1>Welcome</h1>
    <p>This page contains information about some of the basic features to get started and work with your laptop. If you have any questions, please do no hesitate to ask one of your fellow developers.</p>

    <h1>Software</h1>
    <p>This section will explain some of the basic development tools that are pre-installed on your laptop.</p>

    <h2 id="php">PHP</h2>
    <p>Your laptop has the following versions of PHP installed: <?=\implode(', ', $phpVersions)?>.</p>
    <p>
        To switch from PHP versions you can use the <code class="inline">sphp {version}</code> command.
        For example, you can use the following command in your terminal <code>sphp <?=$phpVersions[\count($phpVersions) - 1]?></code>.
        When switching PHP versions, your password will be asked in order to restart the Apache server.
        This is the same password that you use to login to your account on this device.
    </p>

    <h2 id="apache">Apache</h2>
    <p>Each website project that we make or setup needs to be accessible in our browser. Using a a combination of <a href="https://httpd.apache.org/">Apache HTTPD</a> and a little <a href="https://en.wikipedia.org/wiki/Dnsmasq">dnsmasq</a> magic your laptop comes with pre-configured folders for accessing these projects in the browser.</p>
    <p>Apache will automatically look for a <code>index.php</code> or <code>index.html</code> in your <code>DocumentRoot</code>. This website is currently being served from the DocumentRoot at <code><?=$_SERVER['DOCUMENT_ROOT']?></code> with the hostname <code><?=$_SERVER['HTTP_HOST']?></code>.</p>
    <p>Each project can be accessed under the TLDs <code>.app.test</code> or <code>.dev.test</code>. To access these projects we have setup two basic folder structures.</p>
    <table class="table">
        <thead>
            <tr>
            <th scope="col">TLD</th>
            <th scope="col">DocumentRoot</th>
            <th scope="col">Framework</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <th scope="row">{project}.app.test</th>
                <td>/Users/<?=\get_current_user()?>/Development/http/app/{project}/public</td>
                <td>Atabase 3</td>
            </tr>
            <tr>
                <th scope="row">{subdomain}.{project}.app.test</th>
                <td>/Users/<?=\get_current_user()?>/Development/http/app/{project}/public</td>
                <td>Atabase 3</td>
            </tr>
            <tr>
                <th scope="row">{project}.dev.test</th>
                <td>/Users/<?=\get_current_user()?>/Development/http/dev/{project}/www</td>
                <td>Atabase 2</td>
            </tr>
            <tr>
                <th scope="row">{subdomain}.{project}.dev.test</th>
                <td>/Users/<?=\get_current_user()?>/Development/http/dev/{project}/{subdomain}</td>
                <td>Atabase 2</td>
            </tr>
        </tbody>
    </table>
    <p>
        Try creating a website at <code>example.app.test</code> with <code><?=\htmlentities('<h1>Hello World</h1>')?></code>.
        If you succeeded with setting it up you should be able to go to <a href="http://example.app.test/" target="_blank">http://example.app.test/</a> and see "Hello World" instead of "Not Found" in your browser.
        For a more advanced example you can try looking for the folder with the source code of this page that you are currently reading.
    </p>

    <h2 id="mysql">MySQL</h2>
    <p>
        In order to create a persitent state and store information for our applications, we make use of the database software <a href="https://en.wikipedia.org/wiki/MySQL">MySQL</a>.
        Since our frameworks use <a href="https://en.wikipedia.org/wiki/Object-relational_mapping">object-relational mapping (ORM)</a> we do not often write raw <a href="https://dev.mysql.com/doc/mysql-tutorial-excerpt/5.5/en/tutorial.html">SQL queries</a> but it is still very important to learn.
        You can use the application <a href="https://www.sequelpro.com/">SequelPro</a> to navigate your database with a graphical interface. This is easier then writing a query everytime in your terminal.
    </p>
    <p>
        This laptop has been setup with a MySQL 5.7 server and default credentials to keep compatibility with all of our projects.
        It cannot be accessed by other computers on the same network.
    </p>
    <table class="table">
        <tbody>
            <tr>
                <th scope="row" width="150">Host</th>
                <td>127.0.0.1</td>
            </tr>
            <tr>
                <th scope="row">Username</th>
                <td>root</td>
            </tr>
            <tr>
                <th scope="row">Password</th>
                <td>secret</td>
            </tr>
        </tbody>
    </table>

    <h1>Frameworks</h1>
    <p>
        A framework is an abstraction in which software providing generic functionality can be selectively changed by additional user-written code, thus providing application-specific software.
        It provides a standard way to build and deploy applications.
        We apply two different backend frameworks: Atabase 2 and Atabase 3.
    </p>

    <h2 id="atabase2">Atabase 2</h2>
    <p>
        This is our legacy framework.
        It is maintained for older projects and requires a setup that some may consider complicated.
        Atabase 2 projects are always setup under the <code>.dev.test</code> TLD because it's DocumentRoot is the same as project root.
        To read more about how to setup an Atabase 2 project, please read further about it at <a href="https://tutorials.atabix.com/basics/setup_atabase2_locally/">https://tutorials.atabix.com/basics/setup_atabase2_locally/</a>.
    </p>

    <h2 id="atabase3">Atabase 3</h2>
    <p>
        This is currently our actively used framework for new projects.
        Atabase 3 projects are always setup under the <code>.app.test</code> TLD because it's DocumentRoot lives in the folder <code>/public</code> of the project.
        Because Atabase 3 is an extension of the Laravel framework, please follow the laravel installation guide found at <a href="https://devmarketer.io/learn/setup-laravel-project-cloned-github-com/">https://devmarketer.io/learn/setup-laravel-project-cloned-github-com/</a>.
    </p>
</div>

<?=view('templates.footer')?>
