package all

import (
	// Initialize all adapters by importing this package
	_ "github.com/cornerjob/transporter/pkg/adaptor/elasticsearch"
	_ "github.com/cornerjob/transporter/pkg/adaptor/file"
	_ "github.com/cornerjob/transporter/pkg/adaptor/mongodb"
	_ "github.com/cornerjob/transporter/pkg/adaptor/rethinkdb"
	_ "github.com/cornerjob/transporter/pkg/adaptor/transformer"
)
